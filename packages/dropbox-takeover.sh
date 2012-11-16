if [ ! -d ~/Dropbox ]; then
  echo 'Dropbox is required for this script'
  exit 0
fi
if [ ! -d ~/Dropbox/Office ]; then
  mkdir ~/Dropbox/Office
fi

# Takeover Desktop
if [ -d ~/Dropbox/Office/Desktop ]; then
  # If exists, move contents
  sudo mv ~/Desktop/* ~/Dropbox/Office/Desktop/
  sudo rm -f ~/Desktop
else
  # If doesnt exist, create and link
  sudo mv ~/Desktop ~/Dropbox/Office/Desktop
fi
ln -s ~/Dropbox/Office/Desktop ~/Desktop
