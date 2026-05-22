local M = {}

local MODEL = "qwen2.5-coder:7b"
local JIRA_PATTERN = "([A-Z][A-Z0-9]+%-%d+)"
local GH_PATTERNS = {
  "^[^/]+/(%d+)[_%-]",
  "^[^/]+/(%d+)$",
}

local function notify(msg, level)
  vim.notify("[tim] " .. msg, level)
end

local function detect_ticket(branch)
  local jira = branch:match(JIRA_PATTERN)
  if jira then
    return { kind = "jira", id = jira }
  end
  for _, pattern in ipairs(GH_PATTERNS) do
    local gh = branch:match(pattern)
    if gh then
      return { kind = "gh", id = gh }
    end
  end
  return { kind = "none" }
end

local function format_rule_for(ticket)
  if ticket.kind == "jira" then
    return string.format(
      "Prefix the subject with `%s: ` (the Jira ticket detected in the branch).",
      ticket.id
    )
  end
  if ticket.kind == "gh" then
    return string.format(
      "Use the scoped conventional-commit format `<TYPE>(#%s): <MESSAGE>`, where `<TYPE>` is one of feat, fix, docs, style, refactor, perf, test, chore — pick the most appropriate for the diff.",
      ticket.id
    )
  end
  return "Prefix with one of `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `chore:` — pick the most appropriate for the diff."
end

local function build_prompt(branch, diff)
  local format_rule = format_rule_for(detect_ticket(branch))
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

local function strip_ansi(s)
  return (s:gsub("\27%[[%d;?]*[a-zA-Z]", ""))
end

local function get_branch()
  local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait()
  if result.code ~= 0 then
    notify("Not in a git repository", vim.log.levels.ERROR)
    return nil
  end
  return vim.trim(result.stdout)
end

local function get_staged_diff()
  local result = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()
  if result.code ~= 0 then
    notify("git diff failed: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
    return nil
  end
  local diff = result.stdout or ""
  if vim.trim(diff) == "" then
    notify("No staged changes", vim.log.levels.WARN)
    return nil
  end
  return diff
end

local function insert_message(bufnr, message)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    notify("Commit buffer no longer valid — message discarded", vim.log.levels.WARN)
    return
  end
  local lines = vim.split(message, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)
  notify("Commit message inserted", vim.log.levels.INFO)
end

function M.generate()
  local branch = get_branch()
  if not branch then return end

  local diff = get_staged_diff()
  if not diff then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local prompt = build_prompt(branch, diff)

  notify("Generating commit message...", vim.log.levels.INFO)

  vim.system(
    { "ollama", "run", "--nowordwrap", MODEL },
    { text = true, stdin = prompt },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        notify(
          "Commit message generation failed: " .. (result.stderr or "unknown error"),
          vim.log.levels.ERROR
        )
        return
      end
      local message = vim.trim(strip_ansi(result.stdout or ""))
      if message == "" then
        notify("Empty response from model", vim.log.levels.WARN)
        return
      end
      insert_message(bufnr, message)
    end)
  )
end

return M
