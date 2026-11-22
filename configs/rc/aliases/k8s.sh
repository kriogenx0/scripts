# shellcheck shell=bash
# Kriogenx aliases: k8s

# Kubernetes
alias k='kubectl'
alias kd='k get deployments'

# Context
# - Optional parameter to set context
kx() {
  if [ -n "$1" ]; then
    k config set current-context "$1"
  fi
  k config get-contexts
}
# Namespace
# - Optional parameter is to set current namespace
kn() {
  if [ -n "$1" ]; then
    k config set-context --current --namespace="$1"
  else
    k get namespaces
    echo "Current: `k config view --minify --output 'jsonpath={..namespace}'`"
  fi
}
ksh() {
  k exec -it "$1" -- /bin/bash
}
# K8 Pods
alias kp='k get pods'
alias kpy='k get pod -o yaml'
alias kpj="k get pod -o jsonpath='{.spec.containers[*].name}'"
alias kpd='k delete pod'
alias ke="k get events --sort-by='{.lastTimestamp}'"
alias kew='k get events --watch'
kpl() {
  kubectl logs pod/"$1"
}
ku() {
  if [ -n "$1" ]; then
    k describe kustomizations "$1"
  else
    k get kustomizations
  fi
}
# Config Maps
kcm() {
  if [ -n "$1" ]; then
    k describe cm "$1"
  else
    k get cm
  fi
}
