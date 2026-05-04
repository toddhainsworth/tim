local M = {}

local state = {
  popup   = nil,
  tab     = "home",
  ns_id   = vim.api.nvim_create_namespace("tim"),
  data    = {},
}

local TABS = {
  { id = "home",      label = "Home",      key = "H" },
  { id = "versions",  label = "Versions",  key = "V" },
  { id = "changelog", label = "Changelog", key = "C" },
  { id = "help",      label = "Help",      key = "?" },
}

local LOGO = {
  "  ████████╗██╗███╗   ███╗",
  "     ██╔══╝██║████╗ ████║",
  "     ██║   ██║██╔████╔██║",
  "     ██║   ██║██║╚██╔╝██║",
  "     ██║   ██║██║ ╚═╝ ██║",
  "     ╚═╝   ╚═╝╚═╝     ╚═╝",
}

local function win_size()
  return {
    width  = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
  }
end

local function build_tabbar()
  local parts = {}
  for _, t in ipairs(TABS) do
    table.insert(parts, t.label .. " [" .. t.key .. "]")
  end
  return "  " .. table.concat(parts, "    ")
end

-- Each render_* returns { lines = {}, highlights = {} }
-- Highlight rows are 0-indexed relative to the content area (after the tab bar + blank line).
-- render() and render_view_only() offset them by +2 when applying to the buffer.

local function render_home()
  local lines = {}

  for _, l in ipairs(LOGO) do
    table.insert(lines, l)
  end
  table.insert(lines, "")

  local current = state.data.current
  local latest  = state.data.latest

  table.insert(lines, "  version:  " .. (current or "unknown"))

  if current and latest and current ~= latest then
    table.insert(lines, "  status:   update available \xe2\x86\x92 " .. latest)
  elseif not current then
    table.insert(lines, "  status:   no version tags found")
  else
    table.insert(lines, "  status:   up to date")
  end

  table.insert(lines, "")
  table.insert(lines, "  <CR> versions    u update    q close")

  return { lines = lines, highlights = {} }
end

local function render_versions()
  local versions = state.data.versions

  if not versions then
    return { lines = { "  Loading..." }, highlights = {} }
  end

  if #versions == 0 then
    return { lines = { "  no versions available" }, highlights = {} }
  end

  local current = state.data.current
  local latest  = versions[1]
  local cursor  = state.data.versions_cursor or 1
  local lines = {}
  local highlights = {}

  for i, v in ipairs(versions) do
    local prefix = (i == cursor) and "  > " or "    "
    local suffix = ""
    if v == latest and v == current then
      suffix = "  (latest, current)"
    elseif v == latest then
      suffix = "  (latest)"
    elseif v == current then
      suffix = "  (current)"
    end
    table.insert(lines, prefix .. v .. suffix)
    if i == cursor then
      table.insert(highlights, { row = i - 1, col_start = 0, col_end = -1, group = "CursorLine" })
    end
  end

  return { lines = lines, highlights = highlights }
end

local function render_changelog()
  local sections = state.data.sections

  if not sections then
    return { lines = { "  Loading..." }, highlights = {} }
  end

  if #sections == 0 then
    return { lines = { "  no changelog available" }, highlights = {} }
  end

  local lines = {}
  local highlights = {}

  for _, section in ipairs(sections) do
    local tag_row = #lines
    table.insert(lines, "  " .. section.tag)
    table.insert(highlights, { row = tag_row, col_start = 0, col_end = -1, group = "TimTagHeader" })
    for _, commit in ipairs(section.commits) do
      table.insert(lines, "    " .. commit)
    end
    table.insert(lines, "")
  end
  if lines[#lines] == "" then table.remove(lines) end

  return { lines = lines, highlights = highlights }
end

local function render_help()
  local lines = {
    "  Keybindings",
    "  " .. string.rep("\xe2\x94\x80", 30),
    "  <Tab> / <S-Tab>    next / prev tab",
    "  H                  Home",
    "  V                  Versions",
    "  C                  Changelog",
    "  ?                  Help",
    "  q / <Esc>          close",
    "",
    "  Versions tab",
    "  " .. string.rep("\xe2\x94\x80", 30),
    "  j / k              navigate",
    "  <CR>               checkout version",
    "",
    "  Home tab",
    "  " .. string.rep("\xe2\x94\x80", 30),
    "  <CR>               open Versions",
    "  u                  run update",
  }
  return { lines = lines, highlights = {} }
end

local VIEW_RENDERERS = {
  home      = render_home,
  versions  = render_versions,
  changelog = render_changelog,
  help      = render_help,
}

local function apply_tabbar_highlights(bufnr)
  local col = 2
  for _, t in ipairs(TABS) do
    local label_with_key = t.label .. " [" .. t.key .. "]"
    local hl = (t.id == state.tab) and "TimTabActive" or "TimTabInactive"
    vim.api.nvim_buf_add_highlight(bufnr, state.ns_id, hl, 0, col, col + #label_with_key)
    col = col + #label_with_key + 4
  end
end

local function apply_view_highlights(bufnr, highlights)
  for _, h in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(bufnr, state.ns_id, h.group, h.row + 2, h.col_start, h.col_end)
  end
end

local function render()
  if not state.popup then return end
  local bufnr = state.popup.bufnr

  local tabbar = build_tabbar()
  local view = VIEW_RENDERERS[state.tab]()

  local all_lines = { tabbar, "" }
  for _, l in ipairs(view.lines) do
    table.insert(all_lines, l)
  end

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_clear_namespace(bufnr, state.ns_id, 0, -1)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, all_lines)
  vim.bo[bufnr].modifiable = false

  apply_tabbar_highlights(bufnr)
  apply_view_highlights(bufnr, view.highlights)
end

-- Rewrites only lines 2+ (content area). Tab bar highlights are preserved since we
-- only clear the namespace from row 2 onwards.
local function render_view_only()
  if not state.popup then return end
  local bufnr = state.popup.bufnr
  local view = VIEW_RENDERERS[state.tab]()

  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_clear_namespace(bufnr, state.ns_id, 2, -1)
  vim.api.nvim_buf_set_lines(bufnr, 2, -1, false, view.lines)
  vim.bo[bufnr].modifiable = false

  apply_view_highlights(bufnr, view.highlights)
end

local function async_fetch(callback)
  vim.system(
    { "git", "-C", vim.fn.stdpath("config"), "fetch", "--tags", "--quiet" },
    { text = true },
    vim.schedule_wrap(callback)
  )
end

local function load_tab_data(tab_id)
  local git = require("tim.git")
  if tab_id == "versions" and not state.data.versions then
    async_fetch(function()
      local current = git.current_version()
      state.data.current = state.data.current or current
      state.data.latest  = state.data.latest  or git.latest_version()
      local versions = git.list_versions()
      if #versions == 0 then
        vim.notify("[tim] no versions available", vim.log.levels.WARN)
        return
      end
      M.set_versions(versions)
    end)
  elseif tab_id == "changelog" and not state.data.sections then
    async_fetch(function()
      local sections = git.full_changelog()
      if #sections == 0 then
        vim.notify("[tim] no changelog available", vim.log.levels.WARN)
        return
      end
      M.set_sections(sections)
    end)
  end
end

local function checkout_version(selected)
  local git = require("tim.git")
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
end

local function setup_keymaps(bufnr)
  local function map(key, fn)
    vim.keymap.set("n", key, fn, { buffer = bufnr, silent = true, nowait = true })
  end

  map("q",     function() M.close() end)
  map("<Esc>", function() M.close() end)

  local tab_ids = vim.tbl_map(function(t) return t.id end, TABS)

  map("<Tab>", function()
    for i, id in ipairs(tab_ids) do
      if id == state.tab then
        M.switch_tab(tab_ids[(i % #tab_ids) + 1])
        return
      end
    end
  end)

  map("<S-Tab>", function()
    for i, id in ipairs(tab_ids) do
      if id == state.tab then
        M.switch_tab(tab_ids[((i - 2) % #tab_ids) + 1])
        return
      end
    end
  end)

  map("H", function() M.switch_tab("home") end)
  map("V", function() M.switch_tab("versions") end)
  map("C", function() M.switch_tab("changelog") end)
  map("?", function() M.switch_tab("help") end)

  map("j", function()
    if state.tab ~= "versions" or not state.data.versions then return end
    state.data.versions_cursor = math.min((state.data.versions_cursor or 1) + 1, #state.data.versions)
    render_view_only()
  end)
  map("<Down>", function()
    if state.tab ~= "versions" or not state.data.versions then return end
    state.data.versions_cursor = math.min((state.data.versions_cursor or 1) + 1, #state.data.versions)
    render_view_only()
  end)
  map("k", function()
    if state.tab ~= "versions" or not state.data.versions then return end
    state.data.versions_cursor = math.max((state.data.versions_cursor or 1) - 1, 1)
    render_view_only()
  end)
  map("<Up>", function()
    if state.tab ~= "versions" or not state.data.versions then return end
    state.data.versions_cursor = math.max((state.data.versions_cursor or 1) - 1, 1)
    render_view_only()
  end)

  map("<CR>", function()
    if state.tab == "home" then
      M.switch_tab("versions")
    elseif state.tab == "versions" then
      if not state.data.versions then return end
      local selected = state.data.versions[state.data.versions_cursor or 1]
      if selected then checkout_version(selected) end
    end
  end)

  map("u", function()
    if state.tab == "home" then
      require("tim").run_update()
    end
  end)
end

function M.switch_tab(id)
  state.tab = id
  render()
  load_tab_data(id)
end

function M.set_update_status(current, latest)
  state.data.current = current
  state.data.latest  = latest
  if state.popup and state.tab == "home" then
    render_view_only()
  end
end

function M.set_versions(versions)
  state.data.versions = versions
  state.data.versions_cursor = 1
  if state.data.current then
    for i, v in ipairs(versions) do
      if v == state.data.current then
        state.data.versions_cursor = i
        break
      end
    end
  end
  if state.popup and state.tab == "versions" then
    render_view_only()
  end
end

function M.set_sections(sections)
  state.data.sections = sections
  if state.popup and state.tab == "changelog" then
    render_view_only()
  end
end

function M.open(tab)
  require("tim.highlights").setup()

  state.tab = tab or "home"

  if state.popup then
    render()
    load_tab_data(state.tab)
    return
  end

  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event
  local size = win_size()

  state.popup = Popup({
    enter = true,
    focusable = true,
    border = { style = "rounded" },
    position = "50%",
    size = size,
    buf_options  = { buftype = "nofile", swapfile = false },
    win_options  = { wrap = false, cursorline = false },
  })

  state.popup:mount()
  state.popup:on(event.BufLeave, function()
    vim.schedule(function() M.close() end)
  end)

  setup_keymaps(state.popup.bufnr)
  render()
  load_tab_data(state.tab)
end

function M.close()
  if state.popup then
    state.popup:unmount()
    state.popup = nil
  end
end

return M
