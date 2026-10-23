vim.api.nvim_create_user_command("TermRun", function()
    require("termrun").run()
end, {
    desc = "Run current file in a floating terminal",
})
