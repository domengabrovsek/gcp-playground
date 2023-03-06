#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 restart
MACHINE_NAME=`hostname`
IP=`hostname -I`
HEADER="<h1>Hello from GCP"'!'"</h1>"
P1="<p>My hostname is '${HOSTNAME}'</p>"
P2="<p>My IP is '${IP}'</p>"
HTML="<"'!'"doctypehtml><html><body>${HEADER} ${P1} ${P2}</body></html>"
echo $HTML | tee /var/www/html/index.html