provider "kubectl" {
  apply_retry_count      = 5
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
    command     = "aws"
  }
}


data "kubectl_path_documents" "manifests" {
  pattern = "./k8s_manifests/*.yaml"
}

resource "kubectl_manifest" "my_manifests" {
  count     = length(data.kubectl_path_documents.manifests.documents)
  yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
}