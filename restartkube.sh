while($true)
do
echo $(date) >>~/kubewatch.txt
kubectl get nodes >>~/kubewatch.txt
kubectl get nodes | grep Not | cut -f 1 -d , |cut -f 1 -d N| while read LINE ;do ssh -n ${LINE} sudo systemctl restart kubelet;done
sleep 20

done
