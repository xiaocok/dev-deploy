

### 接口说明

#### URL

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/{api/apis}/{api_version}/namespaces/{namespace}/{resouces}/{resources_name}

- cluster_name：查询资源的所在的集群名称
- namespace：查询的资源所在的namespace名称
- api/apis：
- api_version：资源的api_version，例如：v1(Pod)、apps/v1(Deployment)、apps/batch/v1(CronJob)
- resources：查询的资源类型，例如：deployments/pods等
- resources_name：查询的资源的名称，查询列表数据时，则不需要指定资源名称



#### 认证

采用OAuth认证，在https接口的header使用Authorization: Bearer {access_token}的方式认证

- access_token即为认证的token

认证失败示例

```json
{
    "kind": "Status",
    "apiVersion": "v1",
    "metadata": {},
    "status": "Failure",
    "message": "Unauthorized",
    "reason": "Unauthorized",
    "code": 401
}
```



#### 翻页

```shell
kubectl get --raw "/apis/clusterpedia.io/v1beta1/collectionresources/workloads?onlyMetadata=true&limit=1" | jq
kubectl get --raw="/apis/clusterpedia.io/v1beta1/resources/apis/apps/v1/deployments?limit=10&continue=5"
kubectl get --raw="/apis/clusterpedia.io/v1beta1/resources/apis/apps/v1/deployments?withContinue=true&limit=1" | jq
kubectl get --raw="/apis/clusterpedia.io/v1beta1/resources/apis/apps/v1/deployments?withRemainingCount&limit=1" | jq
```



#### Owner

```shell
kubectl get --raw="/apis/clusterpedia.io/v1beta1/resources/clusters/cluster-1/api/v1/namespaces/default/pods?ownerUID=151ae265-28fe-4734-850e-b641266cd5da&ownerSeniority=1"

kubectl get --raw="/apis/clusterpedia.io/v1beta1/resources/clusters/cluster-1/api/v1/namespaces/default/pods?ownerName=deploy-1&ownerSeniority=1"
```



#### 原生SQL

```shell
URL="/apis/clusterpedia.io/v1beta1/resources/apis/apps/v1/deployments"
kubectl get --raw="$URL?whereSQL=(cluster='global') OR (namespace IN ('kube-system','default'))"
```



### 接口地址示例

#### WorkLoads Apis

##### Container

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/containers

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/containers/{container_name}



##### CronJob

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/batch/v1/namespaces/{namespace}/cronjobs

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/batch/v1/namespaces/{namespace}/cronjobs/{cronjob_name}



##### DaemonSet

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/daemonsets

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/daemonsets/{daemonset_name}



##### Deployment

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/deployments

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/deployments/{deployment_name}



##### Job

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/batch/v1/namespaces/{namespace}/jobs

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/batch/v1/namespaces/{namespace}/jobs/{job_name}



##### Pod

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/pods

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/pods/{pod_name}



##### ReplicaSet

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/replicasets

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/replicasets/{replicaset_name}



##### StatefulSet 

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/statefulsets

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/statefulsets/{statefulset_name}



##### Service Apis

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/services

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/services/{service_name}



#### Config & Storage

##### ConfigMap 

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/configmaps

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/configmaps/{configmap_name}



##### secret

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/secrets

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/secrets/{secret_name}



#### Cluster Apis

##### Namespace 

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace_name}



##### node

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/nodes

/apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/nodes/{node_name}





### 接口示例

#### Deployments

| Title         | 参数                                                         |
| ------------- | ------------------------------------------------------------ |
| URL           | /apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/deployments |
| Method        | GET                                                          |
| Authorization | Bearer {access_token}                                        |

成功示例

```json
{
    "kind": "DeploymentList",
    "apiVersion": "apps/v1",
    "metadata": {},
    "items": [
        {
            "metadata": {
                "name": "coredns",
                "namespace": "kube-system",
                "uid": "c4caa23a-f512-48c7-af44-13ba2aa55c66",
                "resourceVersion": "179077",
                "generation": 1,
                "creationTimestamp": "2023-02-02T13:53:05Z",
                "labels": {
                    "k8s-app": "kube-dns"
                },
                "annotations": {
                    "deployment.kubernetes.io/revision": "1",
                    "shadow.clusterpedia.io/cluster-name": "cluster-example"
                }
            },
            "spec": {
                "replicas": 2,
                "selector": {
                    "matchLabels": {
                        "k8s-app": "kube-dns"
                    }
                },
                "template": {
                    "metadata": {
                        "creationTimestamp": null,
                        "labels": {
                            "k8s-app": "kube-dns"
                        }
                    },
                    "spec": {
                        "volumes": [
                            {
                                "name": "config-volume",
                                "configMap": {
                                    "name": "coredns",
                                    "items": [
                                        {
                                            "key": "Corefile",
                                            "path": "Corefile"
                                        }
                                    ],
                                    "defaultMode": 420
                                }
                            }
                        ],
                        "containers": [
                            {
                                "name": "coredns",
                                "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                                "args": [
                                    "-conf",
                                    "/etc/coredns/Corefile"
                                ],
                                "ports": [
                                    {
                                        "name": "dns",
                                        "containerPort": 53,
                                        "protocol": "UDP"
                                    },
                                    {
                                        "name": "dns-tcp",
                                        "containerPort": 53,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "metrics",
                                        "containerPort": 9153,
                                        "protocol": "TCP"
                                    }
                                ],
                                "resources": {
                                    "limits": {
                                        "memory": "170Mi"
                                    },
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "70Mi"
                                    }
                                },
                                "volumeMounts": [
                                    {
                                        "name": "config-volume",
                                        "readOnly": true,
                                        "mountPath": "/etc/coredns"
                                    }
                                ],
                                "livenessProbe": {
                                    "httpGet": {
                                        "path": "/health",
                                        "port": 8080,
                                        "scheme": "HTTP"
                                    },
                                    "initialDelaySeconds": 60,
                                    "timeoutSeconds": 5,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 5
                                },
                                "readinessProbe": {
                                    "httpGet": {
                                        "path": "/ready",
                                        "port": 8181,
                                        "scheme": "HTTP"
                                    },
                                    "timeoutSeconds": 1,
                                    "periodSeconds": 10,
                                    "successThreshold": 1,
                                    "failureThreshold": 3
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "imagePullPolicy": "IfNotPresent",
                                "securityContext": {
                                    "capabilities": {
                                        "add": [
                                            "NET_BIND_SERVICE"
                                        ],
                                        "drop": [
                                            "all"
                                        ]
                                    },
                                    "readOnlyRootFilesystem": true,
                                    "allowPrivilegeEscalation": false
                                }
                            }
                        ],
                        "restartPolicy": "Always",
                        "terminationGracePeriodSeconds": 30,
                        "dnsPolicy": "Default",
                        "nodeSelector": {
                            "kubernetes.io/os": "linux"
                        },
                        "serviceAccountName": "coredns",
                        "serviceAccount": "coredns",
                        "securityContext": {},
                        "schedulerName": "default-scheduler",
                        "tolerations": [
                            {
                                "key": "CriticalAddonsOnly",
                                "operator": "Exists"
                            },
                            {
                                "key": "node-role.kubernetes.io/master",
                                "effect": "NoSchedule"
                            },
                            {
                                "key": "node-role.kubernetes.io/control-plane",
                                "effect": "NoSchedule"
                            }
                        ],
                        "priorityClassName": "system-cluster-critical"
                    }
                },
                "strategy": {
                    "type": "RollingUpdate",
                    "rollingUpdate": {
                        "maxUnavailable": 1,
                        "maxSurge": "25%"
                    }
                },
                "revisionHistoryLimit": 10,
                "progressDeadlineSeconds": 600
            },
            "status": {
                "observedGeneration": 1,
                "replicas": 2,
                "updatedReplicas": 2,
                "readyReplicas": 2,
                "availableReplicas": 2,
                "conditions": [
                    {
                        "type": "Progressing",
                        "status": "True",
                        "lastUpdateTime": "2023-02-02T15:46:37Z",
                        "lastTransitionTime": "2023-02-02T15:46:37Z",
                        "reason": "NewReplicaSetAvailable",
                        "message": "ReplicaSet \"coredns-74586cf9b6\" has successfully progressed."
                    },
                    {
                        "type": "Available",
                        "status": "True",
                        "lastUpdateTime": "2023-10-09T15:58:31Z",
                        "lastTransitionTime": "2023-10-09T15:58:31Z",
                        "reason": "MinimumReplicasAvailable",
                        "message": "Deployment has minimum availability."
                    }
                ]
            }
        }
    ]
}
```



#### Deployment

| Title         | 参数                                                         |
| ------------- | ------------------------------------------------------------ |
| URL           | /apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/apis/apps/v1/namespaces/{namespace}/deployments/{deployment_name} |
| Method        | GET                                                          |
| Authorization | Bearer {access_token}                                        |

成功示例

```json
{
    "kind": "Deployment",
    "apiVersion": "apps/v1",
    "metadata": {
        "name": "coredns",
        "namespace": "kube-system",
        "uid": "c4caa23a-f512-48c7-af44-13ba2aa55c66",
        "resourceVersion": "179077",
        "generation": 1,
        "creationTimestamp": "2023-02-02T13:53:05Z",
        "labels": {
            "k8s-app": "kube-dns"
        },
        "annotations": {
            "deployment.kubernetes.io/revision": "1",
            "shadow.clusterpedia.io/cluster-name": "cluster-example"
        }
    },
    "spec": {
        "replicas": 2,
        "selector": {
            "matchLabels": {
                "k8s-app": "kube-dns"
            }
        },
        "template": {
            "metadata": {
                "creationTimestamp": null,
                "labels": {
                    "k8s-app": "kube-dns"
                }
            },
            "spec": {
                "volumes": [
                    {
                        "name": "config-volume",
                        "configMap": {
                            "name": "coredns",
                            "items": [
                                {
                                    "key": "Corefile",
                                    "path": "Corefile"
                                }
                            ],
                            "defaultMode": 420
                        }
                    }
                ],
                "containers": [
                    {
                        "name": "coredns",
                        "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                        "args": [
                            "-conf",
                            "/etc/coredns/Corefile"
                        ],
                        "ports": [
                            {
                                "name": "dns",
                                "containerPort": 53,
                                "protocol": "UDP"
                            },
                            {
                                "name": "dns-tcp",
                                "containerPort": 53,
                                "protocol": "TCP"
                            },
                            {
                                "name": "metrics",
                                "containerPort": 9153,
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {
                            "limits": {
                                "memory": "170Mi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "memory": "70Mi"
                            }
                        },
                        "volumeMounts": [
                            {
                                "name": "config-volume",
                                "readOnly": true,
                                "mountPath": "/etc/coredns"
                            }
                        ],
                        "livenessProbe": {
                            "httpGet": {
                                "path": "/health",
                                "port": 8080,
                                "scheme": "HTTP"
                            },
                            "initialDelaySeconds": 60,
                            "timeoutSeconds": 5,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "failureThreshold": 5
                        },
                        "readinessProbe": {
                            "httpGet": {
                                "path": "/ready",
                                "port": 8181,
                                "scheme": "HTTP"
                            },
                            "timeoutSeconds": 1,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "failureThreshold": 3
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "imagePullPolicy": "IfNotPresent",
                        "securityContext": {
                            "capabilities": {
                                "add": [
                                    "NET_BIND_SERVICE"
                                ],
                                "drop": [
                                    "all"
                                ]
                            },
                            "readOnlyRootFilesystem": true,
                            "allowPrivilegeEscalation": false
                        }
                    }
                ],
                "restartPolicy": "Always",
                "terminationGracePeriodSeconds": 30,
                "dnsPolicy": "Default",
                "nodeSelector": {
                    "kubernetes.io/os": "linux"
                },
                "serviceAccountName": "coredns",
                "serviceAccount": "coredns",
                "securityContext": {},
                "schedulerName": "default-scheduler",
                "tolerations": [
                    {
                        "key": "CriticalAddonsOnly",
                        "operator": "Exists"
                    },
                    {
                        "key": "node-role.kubernetes.io/master",
                        "effect": "NoSchedule"
                    },
                    {
                        "key": "node-role.kubernetes.io/control-plane",
                        "effect": "NoSchedule"
                    }
                ],
                "priorityClassName": "system-cluster-critical"
            }
        },
        "strategy": {
            "type": "RollingUpdate",
            "rollingUpdate": {
                "maxUnavailable": 1,
                "maxSurge": "25%"
            }
        },
        "revisionHistoryLimit": 10,
        "progressDeadlineSeconds": 600
    },
    "status": {
        "observedGeneration": 1,
        "replicas": 2,
        "updatedReplicas": 2,
        "readyReplicas": 2,
        "availableReplicas": 2,
        "conditions": [
            {
                "type": "Progressing",
                "status": "True",
                "lastUpdateTime": "2023-02-02T15:46:37Z",
                "lastTransitionTime": "2023-02-02T15:46:37Z",
                "reason": "NewReplicaSetAvailable",
                "message": "ReplicaSet \"coredns-74586cf9b6\" has successfully progressed."
            },
            {
                "type": "Available",
                "status": "True",
                "lastUpdateTime": "2023-10-09T15:58:31Z",
                "lastTransitionTime": "2023-10-09T15:58:31Z",
                "reason": "MinimumReplicasAvailable",
                "message": "Deployment has minimum availability."
            }
        ]
    }
}
```





#### Pods

| Title         | 参数                                                         |
| ------------- | ------------------------------------------------------------ |
| URL           | /apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/pods |
| Method        | GET                                                          |
| Authorization | Bearer {access_token}                                        |

成功示例

```json
{
    "kind": "PodList",
    "apiVersion": "v1",
    "metadata": {},
    "items": [
        {
            "metadata": {
                "name": "coredns-74586cf9b6-2fqjz",
                "generateName": "coredns-74586cf9b6-",
                "namespace": "kube-system",
                "uid": "5e8a560b-f166-4f91-9b8a-280dabafd10d",
                "resourceVersion": "194615",
                "creationTimestamp": "2023-02-02T13:53:19Z",
                "labels": {
                    "k8s-app": "kube-dns",
                    "pod-template-hash": "74586cf9b6"
                },
                "annotations": {
                    "shadow.clusterpedia.io/cluster-name": "cluster-example"
                },
                "ownerReferences": [
                    {
                        "apiVersion": "apps/v1",
                        "kind": "ReplicaSet",
                        "name": "coredns-74586cf9b6",
                        "uid": "4517185a-5301-4bbf-a658-82220bc6395a",
                        "controller": true,
                        "blockOwnerDeletion": true
                    }
                ]
            },
            "spec": {
                "volumes": [
                    {
                        "name": "config-volume",
                        "configMap": {
                            "name": "coredns",
                            "items": [
                                {
                                    "key": "Corefile",
                                    "path": "Corefile"
                                }
                            ],
                            "defaultMode": 420
                        }
                    },
                    {
                        "name": "kube-api-access-l2rn8",
                        "projected": {
                            "sources": [
                                {
                                    "serviceAccountToken": {
                                        "expirationSeconds": 3607,
                                        "path": "token"
                                    }
                                },
                                {
                                    "configMap": {
                                        "name": "kube-root-ca.crt",
                                        "items": [
                                            {
                                                "key": "ca.crt",
                                                "path": "ca.crt"
                                            }
                                        ]
                                    }
                                },
                                {
                                    "downwardAPI": {
                                        "items": [
                                            {
                                                "path": "namespace",
                                                "fieldRef": {
                                                    "apiVersion": "v1",
                                                    "fieldPath": "metadata.namespace"
                                                }
                                            }
                                        ]
                                    }
                                }
                            ],
                            "defaultMode": 420
                        }
                    }
                ],
                "containers": [
                    {
                        "name": "coredns",
                        "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                        "args": [
                            "-conf",
                            "/etc/coredns/Corefile"
                        ],
                        "ports": [
                            {
                                "name": "dns",
                                "containerPort": 53,
                                "protocol": "UDP"
                            },
                            {
                                "name": "dns-tcp",
                                "containerPort": 53,
                                "protocol": "TCP"
                            },
                            {
                                "name": "metrics",
                                "containerPort": 9153,
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {
                            "limits": {
                                "memory": "170Mi"
                            },
                            "requests": {
                                "cpu": "100m",
                                "memory": "70Mi"
                            }
                        },
                        "volumeMounts": [
                            {
                                "name": "config-volume",
                                "readOnly": true,
                                "mountPath": "/etc/coredns"
                            },
                            {
                                "name": "kube-api-access-l2rn8",
                                "readOnly": true,
                                "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                            }
                        ],
                        "livenessProbe": {
                            "httpGet": {
                                "path": "/health",
                                "port": 8080,
                                "scheme": "HTTP"
                            },
                            "initialDelaySeconds": 60,
                            "timeoutSeconds": 5,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "failureThreshold": 5
                        },
                        "readinessProbe": {
                            "httpGet": {
                                "path": "/ready",
                                "port": 8181,
                                "scheme": "HTTP"
                            },
                            "timeoutSeconds": 1,
                            "periodSeconds": 10,
                            "successThreshold": 1,
                            "failureThreshold": 3
                        },
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "imagePullPolicy": "IfNotPresent",
                        "securityContext": {
                            "capabilities": {
                                "add": [
                                    "NET_BIND_SERVICE"
                                ],
                                "drop": [
                                    "all"
                                ]
                            },
                            "readOnlyRootFilesystem": true,
                            "allowPrivilegeEscalation": false
                        }
                    }
                ],
                "restartPolicy": "Always",
                "terminationGracePeriodSeconds": 30,
                "dnsPolicy": "Default",
                "nodeSelector": {
                    "kubernetes.io/os": "linux"
                },
                "serviceAccountName": "coredns",
                "serviceAccount": "coredns",
                "nodeName": "k8s-master",
                "securityContext": {},
                "schedulerName": "default-scheduler",
                "tolerations": [
                    {
                        "key": "CriticalAddonsOnly",
                        "operator": "Exists"
                    },
                    {
                        "key": "node-role.kubernetes.io/master",
                        "effect": "NoSchedule"
                    },
                    {
                        "key": "node-role.kubernetes.io/control-plane",
                        "effect": "NoSchedule"
                    },
                    {
                        "key": "node.kubernetes.io/not-ready",
                        "operator": "Exists",
                        "effect": "NoExecute",
                        "tolerationSeconds": 300
                    },
                    {
                        "key": "node.kubernetes.io/unreachable",
                        "operator": "Exists",
                        "effect": "NoExecute",
                        "tolerationSeconds": 300
                    }
                ],
                "priorityClassName": "system-cluster-critical",
                "priority": 2000000000,
                "enableServiceLinks": true,
                "preemptionPolicy": "PreemptLowerPriority"
            },
            "status": {
                "phase": "Running",
                "conditions": [
                    {
                        "type": "Initialized",
                        "status": "True",
                        "lastProbeTime": null,
                        "lastTransitionTime": "2023-02-02T15:46:35Z"
                    },
                    {
                        "type": "Ready",
                        "status": "True",
                        "lastProbeTime": null,
                        "lastTransitionTime": "2023-11-19T03:40:00Z"
                    },
                    {
                        "type": "ContainersReady",
                        "status": "True",
                        "lastProbeTime": null,
                        "lastTransitionTime": "2023-11-19T03:40:00Z"
                    },
                    {
                        "type": "PodScheduled",
                        "status": "True",
                        "lastProbeTime": null,
                        "lastTransitionTime": "2023-02-02T15:46:35Z"
                    }
                ],
                "hostIP": "192.168.195.128",
                "podIP": "10.244.0.90",
                "podIPs": [
                    {
                        "ip": "10.244.0.90"
                    }
                ],
                "startTime": "2023-02-02T15:46:35Z",
                "containerStatuses": [
                    {
                        "name": "coredns",
                        "state": {
                            "running": {
                                "startedAt": "2023-11-19T03:39:59Z"
                            }
                        },
                        "lastState": {
                            "terminated": {
                                "exitCode": 255,
                                "reason": "Unknown",
                                "startedAt": "2023-11-15T14:46:34Z",
                                "finishedAt": "2023-11-16T15:17:16Z",
                                "containerID": "containerd://ed1928c35813d4195171c9354cc7af378ac0588711740bfe24966e73fcffe115"
                            }
                        },
                        "ready": true,
                        "restartCount": 17,
                        "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                        "imageID": "registry.aliyuncs.com/google_containers/coredns@sha256:5b6ec0d6de9baaf3e92d0f66cd96a25b9edbce8716f5f15dcd1a616b3abd590e",
                        "containerID": "containerd://6819fb158dca3c004885a2bccdf272df840d283c524773a4b2ce96f45e388ac1",
                        "started": true
                    }
                ],
                "qosClass": "Burstable"
            }
        }
    ]
}
```





#### Pod

| Title         | 参数                                                         |
| ------------- | ------------------------------------------------------------ |
| URL           | /apis/clusterpedia.io/v1beta1/resources/clusters/{cluster_name}/api/v1/namespaces/{namespace}/pods/{pod_name} |
| Method        | GET                                                          |
| Authorization | Bearer {access_token}                                        |

成功示例

```json
{
    "kind": "Pod",
    "apiVersion": "v1",
    "metadata": {
        "name": "coredns-74586cf9b6-2fqjz",
        "generateName": "coredns-74586cf9b6-",
        "namespace": "kube-system",
        "uid": "5e8a560b-f166-4f91-9b8a-280dabafd10d",
        "resourceVersion": "194615",
        "creationTimestamp": "2023-02-02T13:53:19Z",
        "labels": {
            "k8s-app": "kube-dns",
            "pod-template-hash": "74586cf9b6"
        },
        "annotations": {
            "shadow.clusterpedia.io/cluster-name": "cluster-example"
        },
        "ownerReferences": [
            {
                "apiVersion": "apps/v1",
                "kind": "ReplicaSet",
                "name": "coredns-74586cf9b6",
                "uid": "4517185a-5301-4bbf-a658-82220bc6395a",
                "controller": true,
                "blockOwnerDeletion": true
            }
        ]
    },
    "spec": {
        "volumes": [
            {
                "name": "config-volume",
                "configMap": {
                    "name": "coredns",
                    "items": [
                        {
                            "key": "Corefile",
                            "path": "Corefile"
                        }
                    ],
                    "defaultMode": 420
                }
            },
            {
                "name": "kube-api-access-l2rn8",
                "projected": {
                    "sources": [
                        {
                            "serviceAccountToken": {
                                "expirationSeconds": 3607,
                                "path": "token"
                            }
                        },
                        {
                            "configMap": {
                                "name": "kube-root-ca.crt",
                                "items": [
                                    {
                                        "key": "ca.crt",
                                        "path": "ca.crt"
                                    }
                                ]
                            }
                        },
                        {
                            "downwardAPI": {
                                "items": [
                                    {
                                        "path": "namespace",
                                        "fieldRef": {
                                            "apiVersion": "v1",
                                            "fieldPath": "metadata.namespace"
                                        }
                                    }
                                ]
                            }
                        }
                    ],
                    "defaultMode": 420
                }
            }
        ],
        "containers": [
            {
                "name": "coredns",
                "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                "args": [
                    "-conf",
                    "/etc/coredns/Corefile"
                ],
                "ports": [
                    {
                        "name": "dns",
                        "containerPort": 53,
                        "protocol": "UDP"
                    },
                    {
                        "name": "dns-tcp",
                        "containerPort": 53,
                        "protocol": "TCP"
                    },
                    {
                        "name": "metrics",
                        "containerPort": 9153,
                        "protocol": "TCP"
                    }
                ],
                "resources": {
                    "limits": {
                        "memory": "170Mi"
                    },
                    "requests": {
                        "cpu": "100m",
                        "memory": "70Mi"
                    }
                },
                "volumeMounts": [
                    {
                        "name": "config-volume",
                        "readOnly": true,
                        "mountPath": "/etc/coredns"
                    },
                    {
                        "name": "kube-api-access-l2rn8",
                        "readOnly": true,
                        "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount"
                    }
                ],
                "livenessProbe": {
                    "httpGet": {
                        "path": "/health",
                        "port": 8080,
                        "scheme": "HTTP"
                    },
                    "initialDelaySeconds": 60,
                    "timeoutSeconds": 5,
                    "periodSeconds": 10,
                    "successThreshold": 1,
                    "failureThreshold": 5
                },
                "readinessProbe": {
                    "httpGet": {
                        "path": "/ready",
                        "port": 8181,
                        "scheme": "HTTP"
                    },
                    "timeoutSeconds": 1,
                    "periodSeconds": 10,
                    "successThreshold": 1,
                    "failureThreshold": 3
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "imagePullPolicy": "IfNotPresent",
                "securityContext": {
                    "capabilities": {
                        "add": [
                            "NET_BIND_SERVICE"
                        ],
                        "drop": [
                            "all"
                        ]
                    },
                    "readOnlyRootFilesystem": true,
                    "allowPrivilegeEscalation": false
                }
            }
        ],
        "restartPolicy": "Always",
        "terminationGracePeriodSeconds": 30,
        "dnsPolicy": "Default",
        "nodeSelector": {
            "kubernetes.io/os": "linux"
        },
        "serviceAccountName": "coredns",
        "serviceAccount": "coredns",
        "nodeName": "k8s-master",
        "securityContext": {},
        "schedulerName": "default-scheduler",
        "tolerations": [
            {
                "key": "CriticalAddonsOnly",
                "operator": "Exists"
            },
            {
                "key": "node-role.kubernetes.io/master",
                "effect": "NoSchedule"
            },
            {
                "key": "node-role.kubernetes.io/control-plane",
                "effect": "NoSchedule"
            },
            {
                "key": "node.kubernetes.io/not-ready",
                "operator": "Exists",
                "effect": "NoExecute",
                "tolerationSeconds": 300
            },
            {
                "key": "node.kubernetes.io/unreachable",
                "operator": "Exists",
                "effect": "NoExecute",
                "tolerationSeconds": 300
            }
        ],
        "priorityClassName": "system-cluster-critical",
        "priority": 2000000000,
        "enableServiceLinks": true,
        "preemptionPolicy": "PreemptLowerPriority"
    },
    "status": {
        "phase": "Running",
        "conditions": [
            {
                "type": "Initialized",
                "status": "True",
                "lastProbeTime": null,
                "lastTransitionTime": "2023-02-02T15:46:35Z"
            },
            {
                "type": "Ready",
                "status": "True",
                "lastProbeTime": null,
                "lastTransitionTime": "2023-11-19T03:40:00Z"
            },
            {
                "type": "ContainersReady",
                "status": "True",
                "lastProbeTime": null,
                "lastTransitionTime": "2023-11-19T03:40:00Z"
            },
            {
                "type": "PodScheduled",
                "status": "True",
                "lastProbeTime": null,
                "lastTransitionTime": "2023-02-02T15:46:35Z"
            }
        ],
        "hostIP": "192.168.195.128",
        "podIP": "10.244.0.90",
        "podIPs": [
            {
                "ip": "10.244.0.90"
            }
        ],
        "startTime": "2023-02-02T15:46:35Z",
        "containerStatuses": [
            {
                "name": "coredns",
                "state": {
                    "running": {
                        "startedAt": "2023-11-19T03:39:59Z"
                    }
                },
                "lastState": {
                    "terminated": {
                        "exitCode": 255,
                        "reason": "Unknown",
                        "startedAt": "2023-11-15T14:46:34Z",
                        "finishedAt": "2023-11-16T15:17:16Z",
                        "containerID": "containerd://ed1928c35813d4195171c9354cc7af378ac0588711740bfe24966e73fcffe115"
                    }
                },
                "ready": true,
                "restartCount": 17,
                "image": "registry.aliyuncs.com/google_containers/coredns:v1.8.6",
                "imageID": "registry.aliyuncs.com/google_containers/coredns@sha256:5b6ec0d6de9baaf3e92d0f66cd96a25b9edbce8716f5f15dcd1a616b3abd590e",
                "containerID": "containerd://6819fb158dca3c004885a2bccdf272df840d283c524773a4b2ce96f45e388ac1",
                "started": true
            }
        ],
        "qosClass": "Burstable"
    }
}
```

失败示例

```json
{
    "kind": "Status",
    "apiVersion": "v1",
    "metadata": {},
    "status": "Failure",
    "message": "pods \"coredns-74586cf9b6-2fqjx\" not found",
    "reason": "NotFound",
    "details": {
        "name": "coredns-74586cf9b6-2fqjx",
        "kind": "pods"
    },
    "code": 404
}
```

