if ! test -d ~/Sites/kriogenx ; then

  mkdir ~/Sites/kriogenx
  cd ~/Sites/kriogenx

  git clone git@bitbucket.org:kriogenx/dev.kriogenx.net.git
fi


mv ~/.bashrc ~/.bashrc_old
cp ~/Sites/kriogenx/dev.kriogenx.net/scripts/bashrc-install ~/.bashrc
