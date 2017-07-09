
*  *    * * *   dinor   bash /home/dinor/restart.sh

Copy the private key and public key to the master
copy the file restart.sh to any master you want to be a watcher.
ssh-agent bash
ssh-add ~/.ssh/id_rsa
set the crontab in /var/etc/crontab to :*  *    * * *   dinor   bash /home/dinor/restart.sh
restart cron systemctl restart cron
systemctl restart rsyslog
you are done -- now when a node will become not ready the watcher will restart the kubelet service.



HOW THE SCRIPT WORKS :





