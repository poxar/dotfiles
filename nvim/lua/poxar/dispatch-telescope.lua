local M = {}

-- Filetype-specific targets (edit freely)
M.targets_by_ft = {
  rust = {
    "cargo check",
    "cargo build",
    "cargo test",
    "cargo bench",
  },
  vala = {
    "ninja -C build",
    "meson build --prefix=/usr",
  }
}

-- Get current filetype targets
function M.get_targets()
  local targets = vim.b.dispatch_targets

  print(targets)

  if targets and #targets > 0 then
    return targets
  end

  print("No dispatch targets defined.")
  return nil
end

-- Telescope picker for :Focus
function M.pick_focus()
  local targets = M.get_targets()
  if not targets then
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get current active focus
  local focus_list = vim.fn["dispatch#focus"]()
  local current_focus = "No focus selected"

  if type(focus_list) == "table" and #focus_list > 0 then
    -- Strip ":Dispatch " prefix to get just the target name
    current_focus = focus_list[1]:gsub("^:Dispatch%s+", "")
  end

  -- Finally build the picker
  pickers.new({
    prompt_title = "Select Dispatch Focus (" .. current_focus .. ")",
    layout_strategy = "vertical",
    layout_config = { width = 0.3, height = 0.4 },
    previewer = false,
  }, {
    finder = finders.new_table({ results = targets }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local function on_select()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("Focus " .. selection[1])
      end

      map("i", "<CR>", on_select)
      map("n", "<CR>", on_select)
      return true
    end,
  }):find()
end

return M
