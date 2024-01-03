A = vim.api
O = vim.opt
C = vim.cmd
G = vim.g
K = vim.keymap
F = vim.fn

--- Debugger
---@param obj any
---@return any
-- Used to wrap up an object inline to get useful logging information.
function P(obj)
  print(vim.inspect(obj))
  return obj
end

--- Protected call with handler
---@param handler any
---@param f function
---@param ... unknown
---@return any
-- Allows one to use a predefined handler to manage a protected call,
-- without inspecting the status after the fact.
function Pcall(handler, f, ...)
  local success, value = pcall(f, unpack(...))
  if not success then
    return P(handler(f, unpack(...)))
  end
  return value
end
