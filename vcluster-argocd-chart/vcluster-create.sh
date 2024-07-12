#!/bin/bash
export user=$1
usage='error: Usage: vcluster-create.sh username'
if [ -z $user ]; then echo $usage; exit 1; fi

username=$(echo $user | sed 's/@/-at-/g' | sed 's/\./-dot-/g')
export KUBECONFIG=/kube/kubeconfig
export argocdpassword=$(cat /argocd/password)
kubectl version 
argocd version --server $argocdhost
echo $argocdhost
vcluster version
sed -e "s/USERNAME/$username/g" /init/init-vcluster.yaml > init.yaml
kubectl -n $username create -f init.yaml

kubectl -n $username get issuer
kubectl -n $username get ing

ingresshost=$(kubectl -n $username get ing vcluster-ingress -o jsonpath='{.spec.rules[0].host}')
echo
echo
echo $ingresshost is the dns name of ingress
echo
echo
sed -e "s/INGRESSHOST/$ingresshost/g" /values/values.yaml > values.yaml
cat values.yaml
vcluster create $username -n $username --connect=false -f values.yaml
sleep 30
vcluster connect $username -n $username --update-current=false --server=https://"$ingresshost"
kubectl --kubeconfig=kubeconfig.yaml get ns

kubectl create secret generic $username-config --from-file=kubeconfig.yaml -n <ARGOCD_NAMESPACE>

context=$(kubectl --kubeconfig=kubeconfig.yaml config get-contexts -o name)
echo
echo
echo $context is the context
echo
echo

argocd login $argocdhost --username=admin --password=$argocdpassword
argocd cluster add $context --kubeconfig=kubeconfig.yaml -y
argocd cluster list | grep $username
