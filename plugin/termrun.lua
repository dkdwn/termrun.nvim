vim.api.nvim_create_user_command("Compile", function()
    require("termrun").run()
end, {
    desc = "Run current file in a floating terminal",
})
