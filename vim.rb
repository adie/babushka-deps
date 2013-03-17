dep 'configured vim' do
  requires 'gvim.bin', 'vimfiles'
end

dep 'vim.bin'
dep 'gvim.bin'

dep 'vimfiles', :username do
  username.default(shell('whoami'))
  requires 'git',
    'cloned vimfiles repo'.with(:username => username),
    'vimrc.symlink'.with(:username => username),
    'gvimrc.symlink'.with(:username => username),
    'install vundle.task'.with(:username => username)
end

dep 'cloned vimfiles repo', :username, :vimfiles_repo do
  username.default(shell('whoami'))
  vimfiles_repo.default('https://github.com/adie/vimfiles.git')
  met? {
    "~#{username}/.vim/.git".p.exists?
  }
  meet {
    shell "git clone #{vimfiles_repo} ~#{username}/.vim", :as => username
  }
end

dep 'cloned vundle repo', :username do
  met? {
    "~#{username}/.vim/bundle/vundle/.git".p.exists?
  }
  meet {
    shell "git clone https://github.com/gmarik/vundle.git ~#{username}/.vim/bundle/vundle", :as => username
  }
end

dep 'install vundle.task', :username do
  username.default(shell('whoami'))
  requires 'cloned vundle repo'.with(username)
  run {
    system %{vim +BundleInstall +qa}
  }
end

dep 'update vundle.task', :username do
  username.default(shell('whoami'))
  requires 'cloned vundle repo'.with(username)
  run {
    system %{vim +BundleInstall! +qa}
  }
end

dep 'vimrc.symlink', :username do
  username.default(shell('whoami'))
  requires 'cloned vimfiles repo'.with(:username => username)
  source "~#{username}/.vim/.vimrc"
  destination "~#{username}/.vimrc"
end

dep 'gvimrc.symlink', :username do
  username.default(shell('whoami'))
  requires 'cloned vimfiles repo'.with(:username => username)
  source "~#{username}/.vim/.gvimrc"
  destination "~#{username}/.gvimrc"
end
