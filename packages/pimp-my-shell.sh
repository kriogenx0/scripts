#!/usr/bin/env sh

if [[ ! -e ~/.oh-my-zsh ]]; then
  read -p "Install ZSH? y/n" install_zsh

  # Install ZSH
  if [[ $install_zsh = 'y' ]]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  fi
else
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

if [[ ! -e ~/.profile ]]; then
  echo '#!/usr/bin/env sh' > ~/.profile
fi
if [[ -e ~/.profile ]] && [[ ! `cat ~/.profile` =~ 'kriogenx' ]]; then
  echo 'source ~/Sites/kriogenx/scripts/configs/bashrc' >> ~/.profile
  echo 'si' >> ~/.profile
  echo '# Customize Here' >> ~/.profile
fi

if [[ ! -f ~/.bash_profile ]] || [[ -z `cat ~/.bash_profile | grep '~/.profile'` ]]; then
  echo 'source ~/.profile' >> ~/.bash_profile
fi
