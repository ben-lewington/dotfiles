function list_plugin_submodules --description "list the git submodules"
  set -l root_git_dir (git rev-parse --show-toplevel)
  for folder in $root_git_dir/src/.local/share/nvim/site/pack/packer/{opt, start}
    ls -d $folder/* 2> /dev/null
  end
end


