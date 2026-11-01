-- Enable automatic Tree-sitter highlighting for supported languages
-- Neovim includes parsers for C, Diff, Lua, Markdown, Vimscript, and Vimdoc
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript", "typescript", "typescriptreact", "python",
  callback = function()
    vim.treesitter.start()
  end,
})
