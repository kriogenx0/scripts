if [[ -f ~/.profile ]]; then
  echo '~/.profile exists.  please remove or rename to continue'
  exit 1
fi

if [[ -d ~/.oh-my-zsh ]]; then
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

echo 'source ~/.profile' >> ~/.zshrc
echo 'source ~/.profile' >> ~/.bashrc

echo 'source ~/Sites/kriogenx/scripts/configs/bashrc' > ~/.profile
echo 'si' >> ~/.profile
echo '# Customize Here' >> ~/.profile
