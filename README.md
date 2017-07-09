
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
while($true)
do
echo $(date) >>~/kubewatch.txt
kubectl get nodes >>~/kubewatch.txt
kubectl get nodes | grep Not | cut -f 1 -d , |cut -f 1 -d N| while read LINE ;do ssh -n ${LINE} sudo systemctl restart kubelet;done
sleep 5

done



*****
This will output the non ready node :
kubectl get nodes | grep Not | cut -f 1 -d , |cut -f 1 -d N

For example one node is down :

NAME                       STATUS                     AGE       VERSION
k8s-agentpool-41958888-0   NotReady                   4d        v1.6.6
k8s-master-41958888-0      Ready,SchedulingDisabled   4d        v1.6.6
k8s-master-41958888-1      Ready,SchedulingDisabled   4d        v1.6.6
k8s-master-41958888-2      Ready,SchedulingDisabled   4d        v1.6.6

than it will restart it by running the script above from cron :
