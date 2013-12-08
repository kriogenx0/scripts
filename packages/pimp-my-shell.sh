#!/usr/bin/env sh

# Pimp My Shell

if [[ ! -e ~/.oh-my-zsh ]]; then
  read -p "Install ZSH? y/n" install_zsh

  # Install OH MY ZSH
  if [[ $install_zsh = 'y' ]]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  fi

else
  # Update ZSH
  echo $(cd ~/.oh-my-zsh; git pull --rebase)

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

# Build .profile
if [[ ! -e ~/.profile ]]; then
  echo '#!/usr/bin/env sh' > ~/.profile
fi
if [[ -e ~/.profile ]] && [[ ! `cat ~/.profile` =~ 'kriogenx' ]]; then
  echo 'source ~/Sites/kriogenx/scripts/configs/bashrc' >> ~/.profile
  echo 'si' >> ~/.profile
  echo '# Customize Here' >> ~/.profile
fi

# Link .profile
[[ -e ~/.zshrc ]] && [[ `cat ~/.zshrc` =~ 'source ~/.profile' ]] && echo 'source ~/.profile' >> ~/.zshrc
[[ -e ~/.bashrc ]] && [[ `cat ~/.bashrc` =~ 'source ~/.profile' ]] && echo 'source ~/.profile' >> ~/.bashrc
[[ -e ~/.bash_profile ]] && [[ `cat ~/.bash_profile` =~ 'source ~/.profile' ]] && echo 'source ~/.profile' >> ~/.bash_profile
