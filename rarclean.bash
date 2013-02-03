# Unrar Utility v0.5
# Tom Zaki
# 2013

# large text strings
msg="\nOptions:\n1) Unrar files\n2) Cleanup directory\n3) Unrar and clean all immediate subdirectories\n4) Exit"

options=("Unrar files" "Cleanup directory" "Unrar and clean all immediate subdirectories" "Exit")

# unrar
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

# clean
# - removes leftover rar files
# - removes some other junk typically 
#   found in torrent folders
function cl {
   echo "Cleaning up the mess..."
   rm -f *.r?? *.0?? *.sfv *.nfo *.url *.jpg *.jpeg *.txt
   rm -rf Sample/ sample/ Subs/ subs/ Screens/ screens/
}
clear
echo "Options:"
select choice in "${options[@]}"
do
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
         for D in */; do
            cd "$D"
            echo -e "\nWorking in $D"
            ur # unrar
            cl # clean
            echo "Leaving $D"
            cd ..
         done
         echo -e $msg
      ;;
      "Exit" )
         exit
      ;;
   esac
done