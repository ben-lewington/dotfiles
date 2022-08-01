local _M = {}
local packer_path = F.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

_M.bootstrap_required = F.empty(F.glob(packer_path)) > 0

if _M.bootstrap_required then
  bootstrap_packer = F.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    packer_path
  })
  _M.first = bootstrap_packer == nil
  _M.bootstrap_required = false
  C('packadd packer.nvim')
else
  _M.first = false
end

return _M
