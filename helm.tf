provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
      command     = "aws"
    }
  }
}


#Install AWS load balancer contriller with helm chart

resource "helm_release" "helm-ingress" {
  name       = "helm-ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.1.5"
  namespace  = "my-controllers-ns"
  depends_on = [kubectl_manifest.my_controllers_prerequisites]

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = local.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "ingress-controller-sa"
  }
}

#Install External DNS controller with helm

resource "helm_release" "helm-ext-dns" {
  name       = "helm-ext-dns"
  chart      = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "4.12.3"
  namespace  = "my-controllers-ns"
  depends_on = [kubectl_manifest.my_controllers_prerequisites]

  set {
    name  = "provider"
    value = "aws"
  }
  set {
    name  = "aws.region"
    value = "us-east-2"
  }
  set {
    name  = "aws.zoneType"
    value = "public"
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "external-dns-sa"
  }
  set {
    name  = "domainFilters[0]"
    value = "justpipeline.com"
  }
  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }
  set {
    name  = "podSecurityContext.runAsUser"
    value = "0"
  }
  set {
    name  = "registry"
    value = "noop"
  }
}


#Install Traefik controller with helm

resource "helm_release" "helm-traefik" {
  name       = "helm-traefik"
  chart      = "traefik"
  repository = "https://helm.traefik.io/traefik"
  version    = "9.19.1"
  namespace  = "my-controllers-ns"
  values     = [file("./helm_values/traefik/values.yaml")]
}

#Install Prometheus with helm

resource "helm_release" "helm-prometheus" {
  name       = "helm-prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "14.0.0"
  namespace  = "prometheus-ns"
  depends_on = [kubectl_manifest.my_namespaces, kubectl_manifest.my_metric_server]

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }
  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }
}


##Install Grafana with helm

resource "helm_release" "helm-grafana" {
  name       = "helm-grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.9.0"
  namespace  = "default"
  depends_on = [helm_release.helm-prometheus]
  values     = [file("./helm_values/grafana/values.yaml")]
}



