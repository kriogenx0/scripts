if [[ -f ~/.shellrc ]]; then
  echo '~/.shellrc exists.  please remove or rename to continue'
  exit 1
fi

if [[ -z $ZSH ]] ; then
  # Install Theme
  rm -rf ~/.oh-my-zsh/themes/kriogenx.zsh-theme
  ln -s ~/Sites/kriogenx/scripts/configs/kriogenx.zsh-theme ~/.oh-my-zsh/themes/kriogenx.zsh-theme
fi

if [[ -f ~/.zshrc && ! -f ~/.zsh-old ]]; then
  mv ~/.zshrc{,-old}
fi

if [[ -f ~/.bashrc && ! -f ~/.bash-old ]]; then
  mv ~/.bashrc{,-old}
fi

echo 'source ~/.shellrc' >> ~/.zshrc
echo 'source ~/.shellrc' >> ~/.bashrc

echo 'source ~/Sites/kriogenx/scripts/configs/bashrc' > ~/.shellrc
echo 'si' >> ~/.shellrc
echo '# Customize Here' >> ~/.shellrc
