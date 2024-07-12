# vcluster

To create vcluster for a user and add it to ArgoCD.

One time steps

1. Creation of secret with the name kubeconfig

kubectl create secret generic kubeconfig --from-file=kubeconfig=<ARGO_CD_KUBECONFIG> -n <ARGOCD_NAMESPACE>

2. Creation of configmaps

kubectl create configmap init-vcluster --from-file=init-vcluster.yaml -n <ARGOCD_NAMESPACE>

kubectl create configmap vcluster-values-yaml --from-file=values.yaml -n <ARGOCD_NAMESPACE>

kubectl create configmap vcluster-create-script --from-file=vcluster-create.sh -n <ARGOCD_NAMESPACE>


###Steps for each User

In argo-kubectl-vcluster.yaml replace the username and arogcd ingress host and apply to the cluster.

kubectl apply -f argo-kubectl-vcluster.yaml -n <ARGOCD_NAMESPACE>

**TO DO **

Get Kubeconfig file of the vcluster and send it to user.

In ArgoCD namespace a secret will be created with the username provided in the above step . Decode the secret to access to get the kubeconfig file and send to user.

Create Rbac so that only this user can access this cluster. 


