#!/usr/bin/env bash


##############################################################
# 
# Create random glitches with imagemagick generated gradients
#
##############################################################

function e {
  echo -e "\\033[\0;31m$1\\033[\0m"
}



if [[ -z "$1" ]] ; then
  COUNT=10
else 
  COUNT=$1
fi

if ! $(gem list aviglitch -i); then
  e "*****************************************"
  e "You'll need to install the aviglitch gem."
  e "*****************************************"
  e ""
  e "Installing, please enter your password for installing the gem"
  sudo gem install aviglitch
fi

e "Generating gradients."

for i in $(seq 0 $COUNT); do
  convert -size 1920x1080 gradient: -function sinusoid $(($RANDOM%120)),$((-$(($RANDOM%90)))) -virtual-pixel tile -blur 0x6 -auto-level gradient_bands_$(printf "%02d" $i).png 
  e "Completed $i of $COUNT!"
done;

e "Converting frames to AVI"

ffmpeg -i gradient_bands_%02d.png out.avi

e "Glitching with glitch.rb"
ruby ./glitch.rb out.avi glitch.avi

e "Cleaning up!"
for p in gradient_bands_*.png ; do
  e "rm'ing $p"
  rm $p
done;

e "rm'ing out.avi (frames compiled)"
rm out.avi

e "DONE!"
e "Open $(pwd)/glitch.avi to see the result."
