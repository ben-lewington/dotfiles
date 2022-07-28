require('utils.globals')
function P(obj, opts)
  opts = opts or {}
  print(vim.inspect(obj, opts))
  return obj
end

function Pcall(handle, f, ...)
  local success, value = pcall(f, unpack(...))
  if not success then
    return handle(f, unpack(...))
  end
  return value
end
