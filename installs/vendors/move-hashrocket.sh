# Install hashrocket dotmatrix
mkdir ~/Sites/webconfig
mkdir ~/Sites/webconfig/hashrocket
cd ~/Sites/webconfig/hashrocket
git clone https://github.com/hashrocket/dotmatrix.git

# rm ~/.bashrc
rm ~/.bashrc_old
rm ~/.hashrc
rm ~/.vim
rm ~/.vimrc

ln -s ~/Sites/webconfig/hashrocket/dotmatrix/.bashrc ~/
ln -s ~/Sites/webconfig/hashrocket/dotmatrix/.hashrc ~/
ln -s ~/Sites/webconfig/hashrocket/dotmatrix/.vim ~/
ln -s ~/Sites/webconfig/hashrocket/dotmatrix/.vimrc ~/
sh ~/Sites/webconfig/hashrocket/dotmatrix/bin/vimbundles.sh