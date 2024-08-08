return {
    "neovim/nvim-lspconfig",
    opts = {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
    },
}
