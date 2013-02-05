#!/bin/bash
# Fix Permissions
# Tom Zaki
# 02.03.2013

# post-login script that updates the permissions of all files
# within the public directory. saves a *lot* of headaches

echo ""
read -p "Press [Enter] to continue..."
clear
echo "Do you want to update public folder permissions now?"
select yn in "Yes" "No"; do
   case $yn in
      Yes )
         clear
         echo "Updating permissions..."
         sudo chmod -R 777 /home/public/public/
         sudo chown -R public:public /home/public/public/
         echo "Public Folder permission updated."
         exit 0
      ;;
      No )  
        clear
        echo "Public Folder permissions not updated.";
	exit 0
      ;;
   esac
done