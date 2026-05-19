local M = {}

local MODEL = "qwen2.5-coder:7b"

local function build_prompt(branch, diff)
  local jira = branch:match("([A-Z]+%-%d+)")
  local gh = not jira
    and (branch:match("^[^/]+/(%d+)[_%-]") or branch:match("^[^/]+/(%d+)$"))

  local format_rule
  if jira then
    format_rule = string.format(
      "Prefix the subject with `%s: ` (the Jira ticket detected in the branch).",
      jira
    )
  elseif gh then
    format_rule = string.format(
      "Use the scoped conventional-commit format `<TYPE>(#%s): <MESSAGE>`, where `<TYPE>` is one of feat, fix, docs, style, refactor, perf, test, chore — pick the most appropriate for the diff.",
      gh
    )
  else
    format_rule =
      "Prefix with one of `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `chore:` — pick the most appropriate for the diff."
  end

  return string.format([[Write a single git commit message for the staged changes below.

Rules — follow exactly:
- Use the imperative mood ("add", "fix", "refactor" — not "added", "fixes").
- %s
- Subject under 72 characters.
- Add a body only if the change is non-trivial: blank line, then terse bullet points explaining the why.
- Do NOT include any Claude sign-off, co-author trailer, or AI attribution.
- Output ONLY the raw commit message — no code fences, no preamble, no commentary, no reasoning.

Current branch: `%s`

Staged diff:
```
%s
```
]], format_rule, branch, diff)
end

function M.generate()
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()

  local branch_result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait()
  if branch_result.code ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end
  local branch = vim.trim(branch_result.stdout)

  local diff_result = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
  local diff = diff_result.stdout or ""
  if vim.trim(diff) == "" then
    vim.notify("No staged changes", vim.log.levels.WARN)
    return
  end

  local prompt = build_prompt(branch, diff)

  vim.notify("Generating commit message...", vim.log.levels.INFO)

  vim.system(
    { "ollama", "run", MODEL },
    { text = true, stdin = prompt },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify(
          "Commit message generation failed: " .. (result.stderr or "unknown error"),
          vim.log.levels.ERROR
        )
        return
      end

      local message = vim.trim(result.stdout or "")
      if message == "" then
        vim.notify("Empty response from model", vim.log.levels.WARN)
        return
      end

      if not vim.api.nvim_buf_is_valid(bufnr) then
        vim.notify("Commit buffer no longer valid — message discarded", vim.log.levels.WARN)
        return
      end

      local row = 0
      if vim.api.nvim_win_is_valid(winid) and vim.api.nvim_win_get_buf(winid) == bufnr then
        row = vim.api.nvim_win_get_cursor(winid)[1] - 1
      end

      local lines = vim.split(message, "\n", { plain = true })
      vim.api.nvim_buf_set_lines(bufnr, row, row, false, lines)
      vim.notify("Commit message inserted", vim.log.levels.INFO)
    end)
  )
end

return M
