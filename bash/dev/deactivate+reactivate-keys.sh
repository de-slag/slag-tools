#/bin/bash


xmodmap ~/slag-configurations/deactivate-keys.xmodmap
echo "keys deactivated. Press enter to reactivate"
read
xmodmap ~/slag-configurations/activate-keys.xmodmap
