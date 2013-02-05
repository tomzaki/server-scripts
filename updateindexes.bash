#!/bin/bash
# Update Indexes
# Tom Zaki
# 02.05.2013

# post-login script that updates the indexes of all dirs
# within the public directory. saves a *lot* of headaches

echo ""
read -p "Press [Enter] to continue..."
clear
echo "Do you want to update public folder indexes now?"
select yn in "Yes" "No"; do
   case $yn in
      Yes )
         clear
         echo "Updating indexes..."
         cd /home/public/public/
         find . -type d -exec cp -u index.php {} \;
         echo "Public Folder indexes updated!"
         exit 0
      ;;
      No )  
        clear
        echo "Public Folder permissions not updated.";
	exit 0
      ;;
   esac
done