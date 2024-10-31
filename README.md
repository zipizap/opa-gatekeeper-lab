# opa-gatekeeper-lab
OPA-Gatekeeper lab

Simple demo to install OPA-Gatekeeper in a kind-cluster, deploy a ContraintTemplate + Constraint, and finally deploy a pod to trigger an audit

The ConstraintTemplate+Constraint is specially made for debugging, to only show `input.review` var content and nothing else 

Gator was also included there, for another simple test

NOTE: My kind-version is not the latest, and deployed a k8s-1.25 version but it should not matter for this. 

```

❯ ls -l
total 76944
-rwxrwxr-x 1 ub ub       50 oct 31 12:16 01.kind.create.sh
-rwxrwxr-x 1 ub ub      456 oct 31 12:22 02.kind.install-root-certifs.sh
-rwxrwxr-x 1 ub ub      205 oct 30 19:42 10.opa-gatekeeper.install.sh
-rwxrwxr-x 1 ub ub      199 oct 30 19:43 21.k8spaulodebug.constrainttempl_contraint.sh
-rwxrwxr-x 1 ub ub      233 oct 31 11:03 22.logs.gatekeeper.sh
-rwxrwxr-x 1 ub ub      166 oct 30 19:44 23.k8spaulodebug.pod-dryrun.sh
-rwxrwxr-x 1 ub ub       50 oct 31 12:03 99.kind.delete.sh
-rwxr-xr-x 1 ub ub 78694106 oct 30 19:19 gator
-rwxrwxr-x 1 ub ub       91 oct 31 11:55 gator_test.sh
-rw-rw-r-- 1 ub ub      120 oct 31 11:53 k8spaulodebug.pod.yaml
-rw-rw-r-- 1 ub ub    35149 oct 31 12:15 LICENSE
-rw-rw-r-- 1 ub ub       40 oct 31 12:15 README.md
drwxrwxr-x 2 ub ub     4096 oct 31 11:08 samples
drwxrwxr-x 2 ub ub     4096 oct 30 19:38 template_and_constraint
❯
❯
❯ ./01.kind.create.sh
+ kind create cluster
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.25.3) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
❯ k get pod -A
NAMESPACE            NAME                                         READY   STATUS    RESTARTS   AGE
kube-system          coredns-565d847f94-cfxnn                     1/1     Running   0          14s
kube-system          coredns-565d847f94-g9tmv                     1/1     Running   0          14s
kube-system          etcd-kind-control-plane                      1/1     Running   0          29s
kube-system          kindnet-q5dw8                                1/1     Running   0          14s
kube-system          kube-apiserver-kind-control-plane            1/1     Running   0          29s
kube-system          kube-controller-manager-kind-control-plane   1/1     Running   0          27s
kube-system          kube-proxy-jqxwz                             1/1     Running   0          14s
kube-system          kube-scheduler-kind-control-plane            1/1     Running   0          27s
local-path-storage   local-path-provisioner-684f458cdd-p4wrd      1/1     Running   0          14s
❯
❯
❯ ./10.opa-gatekeeper.install.sh
+ kubectl config set-context kind-kind
Context "kind-kind" modified.
+ kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.17.1/deploy/gatekeeper.yaml
namespace/gatekeeper-system created
resourcequota/gatekeeper-critical-pods created
customresourcedefinition.apiextensions.k8s.io/assign.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignimage.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignmetadata.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplate.expansion.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/modifyset.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/mutatorpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/providers.externaldata.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/syncsets.syncset.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
poddisruptionbudget.policy/gatekeeper-controller-manager created
mutatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-mutating-webhook-configuration created
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
❯ ./21.k8spaulodebug.constrainttempl_contraint.sh
+ kubectl apply -f template_and_constraint/k8spaulodebug.constrainttemplate.yaml
constrainttemplate.templates.gatekeeper.sh/k8spaulodebug created
+ kubectl apply -f template_and_constraint/k8spaulodebug.constraint.yaml
error: unable to recognize "template_and_constraint/k8spaulodebug.constraint.yaml": no matches for kind "K8sPauloDebug" in version "constraints.gatekeeper.sh/v1beta1"
# ;) Error is likely due to the constraint being deployed too soon after contrainttemplate was just installed. Retrying solves it ;)
❯ ./21.k8spaulodebug.constrainttempl_contraint.sh
+ kubectl apply -f template_and_constraint/k8spaulodebug.constrainttemplate.yaml
constrainttemplate.templates.gatekeeper.sh/k8spaulodebug unchanged
+ kubectl apply -f template_and_constraint/k8spaulodebug.constraint.yaml
k8spaulodebug.constraints.gatekeeper.sh/k8spaulodebug created
❯
❯ ./22.logs.gatekeeper.sh
+ kubectl logs -n gatekeeper-system --selector=gatekeeper.sh/system=yes --since=0m --prefix --timestamps --follow
+ hl -R err
...
^C


❯ ./23.k8spaulodebug.pod-dryrun.sh
+ kubectl apply -f k8spaulodebug.pod.yaml --dry-run=server
Warning: [k8spaulodebug] REVIEW OBJECT: {"dryRun": true, "kind": {"group": "", "kind": "Pod", "version": "v1"}, "name": "k8spaulodebug", "namespace": "default", "object": {"apiVersion": "v1", "kind": "Pod", "metadata": {"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"v1\",\"kind\":\"Pod\",\"metadata\":{\"annotations\":{},\"name\":\"k8spaulodebug\",\"namespace\":\"default\"},\"spec\":{\"containers\":[{\"image\":\"k8s.gcr.io/pause\",\"name\":\"dummy\"}]}}\n"}, "creationTimestamp": "2024-10-31T11:26:35Z", "managedFields": [{"apiVersion": "v1", "fieldsType": "FieldsV1", "fieldsV1": {"f:metadata": {"f:annotations": {".": {}, "f:kubectl.kubernetes.io/last-applied-configuration": {}}}, "f:spec": {"f:containers": {"k:{\"name\":\"dummy\"}": {".": {}, "f:image": {}, "f:imagePullPolicy": {}, "f:name": {}, "f:resources": {}, "f:terminationMessagePath": {}, "f:terminationMessagePolicy": {}}}, "f:dnsPolicy": {}, "f:enableServiceLinks": {}, "f:restartPolicy": {}, "f:schedulerName": {}, "f:securityContext": {}, "f:terminationGracePeriodSeconds": {}}}, "manager": "kubectl-client-side-apply", "operation": "Update", "time": "2024-10-31T11:26:35Z"}], "name": "k8spaulodebug", "namespace": "default", "uid": "c12b5337-6e3d-4533-846a-d25e1cf42d14"}, "spec": {"containers": [{"image": "k8s.gcr.io/pause", "imagePullPolicy": "Always", "name": "dummy", "resources": {}, "terminationMessagePath": "/dev/termination-log", "terminationMessagePolicy": "File", "volumeMounts": [{"mountPath": "/var/run/secrets/kubernetes.io/serviceaccount", "name": "kube-api-access-xgf4f", "readOnly": true}]}], "dnsPolicy": "ClusterFirst", "enableServiceLinks": true, "preemptionPolicy": "PreemptLowerPriority", "priority": 0, "restartPolicy": "Always", "schedulerName": "default-scheduler", "securityContext": {}, "serviceAccount": "default", "serviceAccountName": "default", "terminationGracePeriodSeconds": 30, "tolerations": [{"effect": "NoExecute", "key": "node.kubernetes.io/not-ready", "operator": "Exists", "tolerationSeconds": 300}, {"effect": "NoExecute", "key": "node.kubernetes.io/unreachable", "operator": "Exists", "tolerationSeconds": 300}], "volumes": [{"name": "kube-api-access-xgf4f", "projected": {"defaultMode": 420, "sources": [{"serviceAccountToken": {"expirationSeconds": 3607, "path": "token"}}, {"configMap": {"items": [{"key": "ca.crt", "path": "ca.crt"}], "name": "kube-root-ca.crt"}}, {"downwardAPI": {"items": [{"fieldRef": {"apiVersion": "v1", "fieldPath": "metadata.namespace"}, "path": "namespace"}]}}]}}]}, "status": {"phase": "Pending", "qosClass": "BestEffort"}}, "oldObject": null, "operation": "CREATE", "options": {"apiVersion": "meta.k8s.io/v1", "dryRun": ["All"], "fieldManager": "kubectl-client-side-apply", "kind": "CreateOptions"}, "requestKind": {"group": "", "kind": "Pod", "version": "v1"}, "requestResource": {"group": "", "resource": "pods", "version": "v1"}, "resource": {"group": "", "resource": "pods", "version": "v1"}, "uid": "3340e001-dbd6-4cc4-8fe8-67cc5b94cb74", "userInfo": {"groups": ["system:masters", "system:authenticated"], "username": "kubernetes-admin"}}
pod/k8spaulodebug created (server dry run)

❯
❯
❯ ./99.kind.delete.sh
+ kind delete cluster
Deleting cluster "kind" ...


```