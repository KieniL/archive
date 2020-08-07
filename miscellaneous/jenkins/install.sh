#/bin/sh


#install jdk which is needed to run jenkins
sudo apt-get update && sudo apt-get install -y default-jdk-headless

#Download GPG key
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

#Add the repository

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo add-apt-repository universe

#Install jenkins
sudo apt-get update && sudo apt-get install -y jenkins

#Return the initial password after installation
echo "Initial password"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

