local M = {}

local state_file = vim.fn.stdpath("data") .. "/tim_last_check"
local check_interval = 86400 -- 24 hours

local function should_check()
  local stat = vim.uv.fs_stat(state_file)
  if not stat then return true end
  return (os.time() - stat.mtime.sec) >= check_interval
end

local function touch_state_file()
  local fd = io.open(state_file, "w")
  if fd then fd:close() end
end

local function async_fetch(callback)
  vim.system(
    { "git", "-C", vim.fn.stdpath("config"), "fetch", "--tags", "--quiet" },
    { text = true },
    vim.schedule_wrap(callback)
  )
end

local function check_for_update(notify_if_current)
  if notify_if_current then
    vim.notify("[tim] checking for updates...", vim.log.levels.INFO)
  end
  local git = require("tim.git")
  async_fetch(function()
    touch_state_file()
    local current = git.current_version()
    local latest = git.latest_version()
    require("tim.ui").set_update_status(current, latest)
    if current and latest and current ~= latest then
      vim.notify(
        string.format("[tim] %s is available — run :Tim update to install", latest),
        vim.log.levels.INFO
      )
    elseif notify_if_current then
      local msg = current
        and string.format("[tim] up to date (%s)", current)
        or "[tim] no version tags found"
      vim.notify(msg, vim.log.levels.INFO)
    end
  end)
end

local commands = {}

commands.version = function()
  local v = require("tim.git").current_version()
  vim.notify(v and ("[tim] " .. v) or "[tim] no version installed", vim.log.levels.INFO)
end

commands.check = function()
  check_for_update(true)
end

function M.run_update()
  vim.notify("[tim] updating...", vim.log.levels.INFO)
  local git = require("tim.git")
  local current = git.current_version()

  vim.system(
    { "git", "-C", vim.fn.stdpath("config"), "pull", "origin", "main" },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("[tim] update failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end
      async_fetch(function()
        local latest = git.latest_version()
        if not latest or latest == current then
          vim.notify("[tim] already up to date", vim.log.levels.INFO)
          return
        end
        vim.notify(
          string.format("[tim] updated to %s — restart Neovim to apply", latest),
          vim.log.levels.INFO
        )
        local commits = current and git.changelog_between(current, latest) or {}
        local ui = require("tim.ui")
        if #commits > 0 then
          ui.set_sections({ { tag = latest, commits = commits } })
          ui.open("changelog")
        end
      end)
    end)
  )
end

commands.update = function()
  M.run_update()
end

commands.versions = function()
  require("tim.ui").open("versions")
end

commands.changelog = function()
  require("tim.ui").open("changelog")
end

function M.setup()
  vim.api.nvim_create_user_command("Tim", function(opts)
    local sub = opts.args:lower()
    if sub == "" then
      local git = require("tim.git")
      local ui = require("tim.ui")
      local current = git.current_version()
      ui.set_update_status(current, git.latest_version())
      ui.open("home")
      return
    end
    if commands[sub] then
      commands[sub]()
    else
      vim.notify("[tim] unknown subcommand: " .. sub, vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function()
      local keys = vim.tbl_keys(commands)
      table.sort(keys)
      return keys
    end,
  })

  if should_check() then
    vim.defer_fn(function() check_for_update(false) end, 3000)
  end
end

return M
