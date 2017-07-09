


Copy the private key and public key to the master where you want to run the watcher.
copy the file restart.sh to any master you want to be a watcher.
ssh-agent bash
ssh-add ~/.ssh/id_rsa


You can use crontab -e put the script there :* * * * * ./restart.sh  
place it without the loop


HOW THE SCRIPT WORKS :
while($true)
do
echo $(date) >>~/kubewatch.txt
kubectl get nodes >>~/kubewatch.txt
kubectl get nodes | grep Not | cut -f 1 -d , |cut -f 1 -d N| while read LINE ;do ssh -n ${LINE} sudo systemctl restart kubelet;done
sleep 30

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

when the script is running it will look for the not ready agents :
then ssh to them an restart kubelet service.
for example :
dinor@k8s-master-41958888-1:/var/log$ kubectl get nodes | grep Not | cut -f 1 -d , |cut -f 1 -d N
k8s-agentpool-41958888-0   

when you run the script :
if the service is ok you will see the output in the log : ~/kubewatch.txt

NAME                       STATUS                     AGE       VERSION
k8s-agentpool-41958888-0   Ready                      5d        v1.6.6
k8s-master-41958888-0      Ready,SchedulingDisabled   5d        v1.6.6
k8s-master-41958888-1      Ready,SchedulingDisabled   5d        v1.6.6
k8s-master-41958888-2      Ready,SchedulingDisabled   5d        v1.6.6
Sun Jul 9 17:54:52 UTC 2017

when things go wrong :
AME                       STATUS                     AGE       VERSION
k8s-agentpool-41958888-0   NotReady                   5d        v1.6.6
k8s-master-41958888-0      Ready,SchedulingDisabled   5d        v1.6.6
k8s-master-41958888-1      Ready,SchedulingDisabled   5d        v1.6.6
k8s-master-41958888-2      Ready,SchedulingDisabled   5d        v1.6.6

now the watcher will restart the kubelet every 30 seconds

untill it becomes ready.

please try and supply feedback.


