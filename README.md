run this stuff to clear any old zsh/vim things and load everything

need to run :PluginInstall in vim as well

cd ${home}
rm -rf .config/antigen .gitignore.d/{zsh,vim} .vim/ftdetect/zsh.vim .gitmodules .vim/bundle/Vundle.vim .zshrc .vimrc .config/vcsh/repo.d/zsh.git .config/vcsh/repo.d/vim.git
vcsh clone https://github.com/torycmos/zsh.git zsh
vcsh zsh submodule add -f https://github.com/zsh-users/antigen.git .config/antigen
vcsh zsh submodule add -f https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
vcsh clone https://github.com/torycmos/vim.git vim
