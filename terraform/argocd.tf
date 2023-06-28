locals {
  # Example annotations when using Nginx ingress controller as shown here https://argoproj.github.io/argo-cd/operator-manual/ingress/#option-1-ssl-passthrough
  argocd_ingress_annotations = {
    "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
    "alb.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
    "alb.ingress.kubernetes.io/target-type"      = "ip"
    "kubernetes.io/ingress.class"                = "alb"
    "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
    "alb.ingress.kubernetes.io/group.name"       = "cognianxtgen"
    "alb.ingress.kubernetes.io/certificate-arn"  = "arn:aws:acm:us-east-2:252078852689:certificate/330e628f-821d-4c8b-9f5c-e19141aaae87"
  }

}

module "argocd" {
  source              = "DeimosCloud/argocd/kubernetes"
  version             = "1.1.2"
  ingress_host        = var.argocd_domain
  ingress_annotations = local.argocd_ingress_annotations
  values = {
    "server.ingress.ingressClassName" = "alb"
    "server.ingressGrpc.enabled"      = "true"
    "server.ingress.enabled"          = "true"
  }

  # Argocd Config
  config = {
    "accounts.admin"        = "apiKey, login"
    "accounts.cognia-admin" = "apiKey, login"
  }

  # Argocd RBAC Config
  rbac_config = {
    "policy.default" = "role:readonly"
    "policy.csv"     = <<POLICY
  p, role:admin-role, applications, *, */*, allow
  p, role:admin-role, projects, *, *, allow
  p, role:admin-role, clusters, *, *, allow
  p, role:admin-role, repositories, *, *, allow
  p, role:admin-role, certificates, *, *, allow
  p, role:admin-role, gpgkeys, *, *, allow
  g, admin, role:admin-role
  g, cognia-admin, role:admin-role
  
POLICY
  }

}
