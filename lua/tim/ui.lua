local M = {}

local function popup_size(lines)
  local max_len = 0
  for _, line in ipairs(lines) do
    max_len = math.max(max_len, #line)
  end
  return {
    width = math.min(math.max(max_len + 4, 40), vim.o.columns - 8),
    height = math.min(#lines + 2, math.floor(vim.o.lines * 0.7)),
  }
end

function M.show_changelog(sections)
  local lines = {}
  for _, section in ipairs(sections) do
    table.insert(lines, section.tag)
    for _, commit in ipairs(section.commits) do
      table.insert(lines, "  " .. commit)
    end
    table.insert(lines, "")
  end
  if lines[#lines] == "" then table.remove(lines) end

  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event
  local size = popup_size(lines)

  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = { top = " Changelog ", top_align = "center" },
    },
    position = "50%",
    size = size,
  })

  popup:mount()
  popup:on(event.BufLeave, function() popup:unmount() end)

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
  vim.bo[popup.bufnr].modifiable = false

  vim.keymap.set("n", "q", function() popup:unmount() end, { buffer = popup.bufnr, silent = true })
end

function M.show_loading(title)
  local Popup = require("nui.popup")
  local popup = Popup({
    enter = false,
    focusable = false,
    border = {
      style = "rounded",
      text = { top = " " .. title .. " ", top_align = "center" },
    },
    position = "50%",
    size = { width = 20, height = 1 },
  })
  popup:mount()
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, { "  Loading..." })
  vim.bo[popup.bufnr].modifiable = false
  return popup
end

function M.show_versions(versions, on_select)
  local Menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event

  local items = {}
  for _, v in ipairs(versions) do
    table.insert(items, Menu.item(v))
  end

  local menu = Menu({
    position = "50%",
    size = {
      width = 20,
      height = math.min(#versions, 20),
    },
    border = {
      style = "rounded",
      text = { top = " Versions ", top_align = "center" },
    },
  }, {
    lines = items,
    keymap = {
      focus_next = { "j", "<Down>" },
      focus_prev = { "k", "<Up>" },
      close = { "q", "<Esc>" },
      submit = { "<CR>" },
    },
    on_submit = function(item) on_select(item.text) end,
  })

  menu:mount()
  menu:on(event.BufLeave, function() menu:unmount() end)
end

return M
