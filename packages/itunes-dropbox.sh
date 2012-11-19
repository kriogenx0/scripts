if [ -d ~/Music/iTunes ]; then
	mv ~/Music/iTunes ~/Music/iTunes2
fi

ln -s ~/Dropbox/Music/iTunes\ Library ~/Music/iTunes 
mkdir ~/Backup
mkdir ~/Backup/Books\ \&\ Tutorials
ln -s ~/Backup/Books\ \&\ Tutorials/Podcasts ~/Dropbox/Music/iTunes\ Library/iTunes\ Music/
ln -s ~/Backup/Books\ \&\ Tutorials/iTunes\ U ~/Dropbox/Music/iTunes\ Library/iTunes\ Music 
ln -s ~/Backup/Books\ \&\ Tutorials/Books ~/Dropbox/Music/iTunes\ Library/iTunes\ Music 
mkdir ~/Backup/Movies
mkdir ~/Backup/Movies/iTunes\ Movies
ln -s ~/Backup/Movies/iTunes\ Movies ~/Dropbox/Music/iTunes\ Library/Movies


osascript -e 'tell application "Finder" to make alias file to POSIX file "/full/path/to/file" at POSIX file "/full/path/to/folder"'
