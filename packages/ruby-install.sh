# RVM Install
if [[ ! -d ~/.rvm ]]; then
  curl -L https://get.rvm.io | bash -s stable --rails
fi

# Ruby Install
sh installs/vendors/install-theinstall.sh

# Get RVM to reload
if [[ -f ~/.rvmrc ]]; then
  echo 'rvm_auto_reload_flag=1' >> ~/.rvmrc
fi

# Uninstall Native Ruby
if [[ -d /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8 ]]; then
  sudo rm -r /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8
fi

# POW
# curl get.pow.cx | sh

