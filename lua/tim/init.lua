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
  local git = require("tim.git")
  async_fetch(function()
    touch_state_file()
    local current = git.current_version()
    local latest = git.latest_version()
    if current and latest and current ~= latest then
      vim.notify(
        string.format("[tim] %s is available — run :Tim Update to install", latest),
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

commands.update = function()
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
        if #commits > 0 then
          require("tim.ui").show_changelog({ { tag = latest, commits = commits } })
        end
      end)
    end)
  )
end

commands.versions = function()
  local git = require("tim.git")
  local ui = require("tim.ui")
  local loading = ui.show_loading("Versions")
  async_fetch(function()
    loading:unmount()
    local versions = git.list_versions()
    if #versions == 0 then
      vim.notify("[tim] no versions available", vim.log.levels.WARN)
      return
    end
    ui.show_versions(versions, function(selected)
      local current = git.current_version()
      if selected == current then
        vim.notify(string.format("[tim] already on %s", selected), vim.log.levels.INFO)
        return
      end
      local choice = vim.fn.confirm(
        string.format("Checkout %s? This will leave you in detached HEAD state.", selected),
        "&Yes\n&No",
        2
      )
      if choice ~= 1 then return end
      vim.system(
        { "git", "-C", vim.fn.stdpath("config"), "checkout", selected },
        { text = true },
        vim.schedule_wrap(function(result)
          if result.code ~= 0 then
            vim.notify("[tim] checkout failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
            return
          end
          vim.notify(
            string.format("[tim] checked out %s — restart Neovim to apply", selected),
            vim.log.levels.INFO
          )
        end)
      )
    end)
  end)
end

commands.changelog = function()
  local ui = require("tim.ui")
  local loading = ui.show_loading("Changelog")
  async_fetch(function()
    loading:unmount()
    local sections = require("tim.git").full_changelog()
    if #sections == 0 then
      vim.notify("[tim] no changelog available", vim.log.levels.WARN)
      return
    end
    ui.show_changelog(sections)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("Tim", function(opts)
    local sub = opts.args:lower()
    if commands[sub] then
      commands[sub]()
    else
      vim.notify("[tim] unknown subcommand: " .. sub, vim.log.levels.ERROR)
    end
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(commands)
    end,
  })

  if should_check() then
    vim.defer_fn(function() check_for_update(false) end, 3000)
  end
end

return M
