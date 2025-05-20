local M = {}

local masonames = require "configs.lsp.mason_names"
local pkgs = require("configs.lsp.mason").servers

M.get_pkgs = function()
  local tools = {}

  local native_lsps = vim.tbl_keys(vim.lsp._enabled_configs)
  vim.list_extend(tools, native_lsps)

  local conform_exists, conform = pcall(require, "conform")

  if conform_exists then
    for _, v in ipairs(conform.list_all_formatters()) do
      local fmts = vim.split(v.name:gsub(",", ""), "%s+")
      vim.list_extend(tools, fmts)
    end
  end

  -- nvim-lint
  local lint_exists, lint = pcall(require, "lint")

  if lint_exists then
    local linters = lint.linters_by_ft

    for _, v in pairs(linters) do
      vim.list_extend(tools, v)
    end
  end

  -- rm duplicates
  for _, v in pairs(tools) do
    if not vim.tbl_contains(pkgs, masonames[v]) then
      table.insert(pkgs, masonames[v])
    end
  end

  return pkgs
end

M.install_all = function()
  vim.cmd "Mason"

  local mr = require "mason-registry"

  mr.refresh(function()
    for _, tool in ipairs(M.get_pkgs()) do
      local p = mr.get_package(tool)

      if not p:is_installed() then
        p:install()
      end
    end
  end)
end

return M
