#!/bin/bash
# User Management Utility
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
  "Add New Ubuntu User" \
  "Add New Samba User" \
  "Delete Ubuntu User" \
  "Delete Samba User" \
  "Exit" \
)

# msg - used to print the string of options
msg="\nOptions:"
i=1
for opt in "${options[@]}"; do
   msg+="\n$i) $opt"
   let i++
done

# Functions

# function: newusr - make new user on server
function newusr {
   echo "Enter User's Full Name"
   read name
   echo "Enter Username"
   read acct
   useradd "$acct" -c "$name" -G "roommates" -m -s /bin/bash
   passwd "$acct"
}

# function: newsmb - make new samba share
function newsmb {
   echo "Enter User's Remote Computer Username"
   read name
   echo "Enter Username"
   read acct
   if id -u $acct >/dev/null 2>&1; then
      smbpasswd -a "$acct"
      echo -ne \
        "\n[$acct]\n \
	comment = $name\n \
	path = /home/$acct\n \
	read only = no\n \
;	browseable = yes\n \
	valid users = $acct\n \
	create mask = 0755" \
      >> /etc/samba/smb.conf
      echo -ne "\n$acct = $name" >> /etc/samba/smbusers
      smbd
      nmbd
   else
      echo "Ubuntu user does not exist."
      echo "Create a new Ubuntu user before creating a new Samba user"
   fi
}

# function: delusr - delete ubuntu user
function delusr {
   echo "Enter Name of User to Delete"
   read acct
   if id -u $acct >/dev/null 2>&1; then
      userdel "$acct"
      echo "Delete $acct's Home Directory? [y/n]:"
      read yn
      if [ $yn == "y" ]; then
         rm -rf /home/"$acct" 
      fi
   else
      echo "Ubuntu user does not exist."
   fi
}

# function: delsmb - delete samba user
function delsmb {
   echo "Enter Username of Account to Delete"
   read acct
   if grep -Fq "$acct =" /etc/samba/smbusers ; then
      sed -i.old '/\['$acct'\]/,/0755/d' /etc/samba/smb.conf
      sed -i.old '/'$acct' =/d' /etc/samba/smbusers
   else
      echo "Samba user dos not exist."
   fi
}

# Main Loop:
clear
# Must run as root 
if [ $(whoami) != "root" ]; then
    echo "You need to run this script as root."
    echo "Use 'sudo bash newuser.bash' then enter your password when prompted."
    exit 1
fi
echo "Options:"
select choice in "${options[@]}"; do
   case "$choice" in
      "Add New Ubuntu User" )
         echo ""
         newusr # make new Ubuntu user
         echo -e $msg
      ;;
      "Add New Samba User" )
         echo ""
         newsmb # make new Samba user
         echo -e $msg
      ;;
      "Delete Ubuntu User" )
         echo ""
         delusr # delete Ubuntu user
         echo -e $msg
      ;;
      "Delete Samba User" )
         echo ""
         delsmb # delete Samba user
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