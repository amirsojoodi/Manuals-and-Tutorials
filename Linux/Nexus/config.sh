#!/bin/bash

# install 

# change the user to your preferred user
myUser="user"
# This file should be next to this script
nexusTarGz="nexus-3.1.0-04-unix.tar.gz"
nexusVer="nexus-3.1.0-04"
changeRepo="changeRepo"

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

sudo cp $changeRepo /usr/bin/
sudo cp settings.xml.orig /home/$myUser/.m2

sudo cp $nexusTarGz /usr/local
cd /usr/local
sudo tar xzf $nexusTarGz
sudo rm $nexusTarGz
sudo ln -s /usr/local/$nexusVer /usr/local/nexus
sudo chown $myUser:$myUser nexus -R
sudo chown $myUser:$myUser $nexusVer -R
sudo chown $myUser:$myUser sonatype-work/ -R

echo "export NEXUS_HOME=\"/usr/local/nexus\"" | tee -a /home/$myUser/.bashrc
source /home/$myUser/.bashrc

NEXUS_HOME="/usr/local/nexus"

echo "Set this variable in $NEXUS_HOME/bin/nexus"
echo "INSTALL4J_JAVA_HOME_OVERRIDE=/usr/lib/jvm/java-8-oracle"

confirm "Do you want to viw nexus file now?(y/n recommended yes)" && sudo vim /usr/local/nexus/bin/nexus

cd $NEXUS_HOME/bin
./nexus run | echo "Type ctrl+c to continue the installation!"

echo "run_as_user=\"$myUser\"" | sudo tee $NEXUS_HOME/bin/nexus.rc

sudo service nexus stop

sudo ln -s $NEXUS_HOME/bin/nexus /etc/init.d/nexus

cd /etc/init.d
sudo update-rc.d nexus defaults

sudo service nexus restart

changeRepo

echo "Installation finished! you can visit configuration UI at (defaults)localhost:8081."
echo "Also your settings.xml file updated in your home directory. to enable maven to nexus or not to use it, run changeRepo"
echo "Make sure to edit settings.xml and settings.xml.orig in the ~/.m2/ directory and put the correct values for <localrepository> and <url> vice versa."

