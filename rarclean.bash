#!/bin/bash
# Unrar Utility
# Tom Zaki
# 02.03.2013

# Variables

# options - all of the choices to present to the user
# - add more options in the location they should
#   appear in the list
# - remember to end each line with " \" and don't
#   leave any trailing spaces
# - also remember to add a case for the new option 
#   in the main loop. If no case is added the script
#   will simply ignore the command gracefully
options=( \
  "Unrar files" \
  "Cleanup directory" \
  "Unrar and clean all immediate subdirectories" \
  "Exit" \
)

# msg - used to print the string of options
msg="\nOptions:"
i=1
for opt in "${options[@]}"; do
   msg+="\n$i) $opt"
   let i++
done

# Fucntions
# - fucntions should be used to separate long 
#   commands from the main loop and should appear
#   before the main loop 

# function: unrar
# - handles a few common types of rar archives
function ur { 
   echo "Unraring..."
   if [ -f *01 ]; then
      unrar e *01
   elif [ -f *.part01.rar ]; then
      unrar e *.part01.rar
   elif [ -f *.part001.rar ]; then   
      unrar e *.part001.rar
   else
      unrar e *.rar
   fi  
}

# function: clean
# - removes leftover rar files
# - removes some other junk typically 
#   found in torrent folders
function cl {
   echo "Cleaning up the mess..."
   rm -f *.r?? *.0?? *.sfv *.nfo *.url *.jpg *.jpeg *.txt
   rm -rf Sample/ sample/ Subs/ subs/ Screens/ screens/
}

# function: sub-directories
# - both unrar's and cleans all immediate 
#   sub directories of the active dir
function sd {
   if [ -f */ ]; then
      for D in */; do
         cd "$D"
         echo -e "\nWorking in $D"
         ur # unrar
         cl # clean
         echo "Leaving $D"
         cd ..
      done
   else
      echo -e "\nThere are no sub-directories in this location..."
   fi
}

# Main Loop:
clear
echo "Options:"
select choice in "${options[@]}"; do
   case "$choice" in
      "Unrar files" )
         echo ""
         ur # unrar
         echo -e $msg
      ;;
      "Cleanup directory" )
         echo ""
         cl # clean
         echo -e $msg
      ;;
      "Unrar and clean all immediate subdirectories" )
         sd # sub-directories 
         echo -e $msg
      ;;
      "Exit" )
         exit 0
      ;;
      * ) # default - gracefully handle unexpected input
         echo -e "\nThis option is either not yet suppoted or does not exist"
         echo -e $msg
      ;;
   esac
done