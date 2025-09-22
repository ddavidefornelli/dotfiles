require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
opts = {
  ensure_installed = {
    "stylua",
    "shfmt",
  },
}
