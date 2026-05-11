local M = {}

local config_path = vim.fn.stdpath("config")

local function git(args)
  local cmd = vim.list_extend({ "git", "-C", config_path }, args)
  local result = vim.system(cmd, { text = true }):wait()
  return (result.code == 0) and vim.trim(result.stdout) or ""
end

function M.fetch(callback)
  vim.system(
    { "git", "-C", config_path, "fetch", "--tags", "--quiet" },
    { text = true },
    vim.schedule_wrap(callback)
  )
end

function M.current_version()
  local v = git({ "describe", "--tags", "--abbrev=0" })
  return v ~= "" and v or nil
end

function M.list_versions()
  local out = git({ "tag", "--list", "--sort=-version:refname", "v*" })
  if out == "" then return {} end
  return vim.tbl_filter(function(v) return v ~= "" end, vim.split(out, "\n"))
end

function M.latest_version()
  return M.list_versions()[1]
end

-- Returns { { tag = "v1.2.0", commits = { "abc1234 feat: ..." } }, ... }
function M.full_changelog()
  local tags = M.list_versions()
  if #tags == 0 then return {} end

  local sections = {}
  for i, tag in ipairs(tags) do
    local prev = tags[i + 1]
    local range = prev and (prev .. ".." .. tag) or tag
    local out = git({ "log", range, "--oneline" })
    local commits = vim.tbl_filter(function(c) return c ~= "" end, vim.split(out, "\n"))
    if #commits > 0 then
      table.insert(sections, { tag = tag, commits = commits })
    end
  end

  return sections
end

-- Returns commits between two tags (or from a tag to HEAD)
function M.changelog_between(from, to)
  local range = to and (from .. ".." .. to) or (from .. "..HEAD")
  local out = git({ "log", range, "--oneline" })
  return vim.tbl_filter(function(c) return c ~= "" end, vim.split(out, "\n"))
end

return M
