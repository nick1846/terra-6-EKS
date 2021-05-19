provider "kubectl" {
  apply_retry_count      = 15
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}


# resource "kubernetes_namespace" "my_controllers_ns" {
#   metadata {
#     name = "my-controllers-ns"
#   }
# }


data "kubectl_path_documents" "namespaces" {
  pattern = "./k8s_manifests/namespaces/*.yaml"
}

resource "kubectl_manifest" "my_namespaces" {
  count     = length(data.kubectl_path_documents.namespaces.documents)
  yaml_body = element(data.kubectl_path_documents.namespaces.documents, count.index)
}

################################
#Apply .yaml manifests from ./k8s_manifests/deployments/


data "kubectl_path_documents" "metric_server" {
  pattern = "./k8s_manifests/deployments/monitoring/metric_server/*.yaml"
}

resource "kubectl_manifest" "my_metric_server" {
  count     = length(data.kubectl_path_documents.metric_server.documents)
  yaml_body = element(data.kubectl_path_documents.metric_server.documents, count.index)  
}

################################
#Apply .yaml manifests from ./k8s_manifests/controllers_prerequisites/

data "kubectl_path_documents" "controllers_prerequisites" {
  pattern = "./k8s_manifests/controllers_prerequisites/*.yaml"
}

resource "kubectl_manifest" "my_controllers_prerequisites" {
  count     = length(data.kubectl_path_documents.controllers_prerequisites.documents)
  yaml_body = element(data.kubectl_path_documents.controllers_prerequisites.documents, count.index)

  depends_on = [kubectl_manifest.my_namespaces]
}

################################
#Apply .yaml manifests from ./k8s_manifests/ingress/


data "kubectl_path_documents" "ingress" {
  pattern = "./k8s_manifests/ingress/*.yaml"
}

resource "kubectl_manifest" "my_ingress" {
  count     = length(data.kubectl_path_documents.ingress.documents)
  yaml_body = element(data.kubectl_path_documents.ingress.documents, count.index)

  depends_on = [    
    kubectl_manifest.my_awx, 
    kubectl_manifest.my_web, 
    kubectl_manifest.my_game,
    helm_release.helm-grafana,
    helm_release.helm-ingress
  ]
}

################################
#Apply .yaml manifests from ./k8s_manifests/deployments/


data "kubectl_path_documents" "awx" {
  pattern = "./k8s_manifests/deployments/awx/*.yaml"
}

resource "kubectl_manifest" "my_awx" {
  count     = length(data.kubectl_path_documents.awx.documents)
  yaml_body = element(data.kubectl_path_documents.awx.documents, count.index)
  depends_on = [kubectl_manifest.my_namespaces]
}

################################
#Apply .yaml manifests from ./k8s_manifests/deployments/


data "kubectl_path_documents" "web_project" {
  pattern = "./k8s_manifests/deployments/web_project/*.yaml"
}

resource "kubectl_manifest" "my_web" {
  count     = length(data.kubectl_path_documents.web_project.documents)
  yaml_body = element(data.kubectl_path_documents.web_project.documents, count.index)  
  depends_on = [kubectl_manifest.my_namespaces]
}

################################
#Apply .yaml manifests from ./k8s_manifests/deployments/


data "kubectl_path_documents" "game" {
  pattern = "./k8s_manifests/deployments/game/*.yaml"
}

resource "kubectl_manifest" "my_game" {
  count     = length(data.kubectl_path_documents.game.documents)
  yaml_body = element(data.kubectl_path_documents.game.documents, count.index)
  depends_on = [kubectl_manifest.my_namespaces]
}