# http://blog.therubymug.com/blog/2011/07/26/the-install-osx-lion.html

mkdir ~/Sites/webconfig

# run script
test -f ~/Sites/webconfig/the_install.sh && rm ~/Sites/webconfig/the_install.sh
curl -s\
  https://raw.github.com/gist/1341873/60ccc411faadf1194941d7b65347ec09b10adac2/the_install.sh \
  -o ~/Sites/webconfig/the_install.sh
chmod 0700 ~/Sites/webconfig/the_install.sh
. ~/Sites/webconfig/the_install.sh


# FIX 
echo "[default]" | sudo tee /etc/nsmb.conf
echo "streams=no" | sudo tee -a /etc/nsmb.conf


# Install homebrew
sudo mkdir /usr/local
sudo chown -R `whoami` /usr/local
curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C /usr/local


# create bash_profile
echo '. "$HOME/.bashrc"' > ~/.bash_profile

# Install MacVim
# brew install macvim

# Install utilities
brew install wget proctools ack ctags-exuberant markdown

# Install ImageMagick
brew install imagemagick

# Get git
brew install git

# Tig
brew install tig