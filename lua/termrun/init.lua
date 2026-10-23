
local M = {}

M.config = {
    commands = {},
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

function M.run()
    local filename = vim.api.nvim_buf_get_name(0)
    local filetype = vim.bo.filetype
    local command = M.config.commands[filetype]

    if not command then
        vim.notify("No command configured for: " .. filetype, vim.log.levels.WARN)
        return
    end

    command = command:gsub("%%f", function()
        return vim.fn.shellescape(filename)
    end)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.6)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = "minimal",
        border = "rounded",
        title = " TermRun ",
        title_pos = "center",
    })

    vim.keymap.set("t", "<Esc>", function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf })

    vim.fn.termopen(command, {
        on_exit = function(_, exit_code)
            vim.schedule(function()
                if exit_code == 0 and vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
            end)
        end,
    })

    vim.cmd("startinsert")
end

return M

