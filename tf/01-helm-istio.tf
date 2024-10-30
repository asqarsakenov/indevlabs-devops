# Helm provider configuration. We configure credentials path to access our minikube/k8s cluster

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }

}

# We assign a variable (link to istio helm repo) to use it multiple times in our .tf file

locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

# Deployment of istio-base helm chart with the default configuration

resource "helm_release" "istio-base" {
  name       = "istio-base"

  repository = local.istio_charts_url
  chart      = "base"
  namespace = "istio-system"
  create_namespace = true

  set {
    name  = "defaultRevision"
    value = "default"
  }
}


# istiod control plane deployment

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = local.istio_charts_url
  chart      = "istiod"
  namespace = "istio-system"
  depends_on = [ helm_release.istio-base ]
  create_namespace = true

}

#  Istio ingress gateway deployment

resource "helm_release" "istio-ingress" {
  name       = "istio-ingress"
  repository = local.istio_charts_url
  chart      = "gateway"
  namespace = "istio-ingress"
  create_namespace = true
  depends_on = [ helm_release.istiod ]
}

# K8s provider configuration to create a custom ns with the needed labels

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}


# Creation of k8s ns with istio-injection enabled label

resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  labels = {
    istio-injection = "enabled"
    }
  }
}

# httpd web server deployment using helm_release resource

resource "helm_release" "httpd-apache" {
  name       = "httpd-apache"
  chart      = "oci://registry-1.docker.io/bitnamicharts/apache"
  depends_on = [ helm_release.istio-ingress ]
  namespace = "app"

}