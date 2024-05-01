return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    fmt = string.lower,
                },
            },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                },
            },
            lualine_z = {
                {
                    "location",
                    icon = "",
                },
            },
        },
        extensions = {
            "nvim-tree"
        },
    },
}
