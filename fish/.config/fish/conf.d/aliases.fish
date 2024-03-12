if status --is-interactive
    which prettyping > /dev/null && alias ping="prettyping --nolegend"
    which htop > /dev/null && alias top="htop"
    abbr -a bi bundle install
    abbr -a be bundle exec
    abbr -a k kubectl
    abbr -a kg kubectl get
    abbr -a kgp kubectl get pods
    abbr -a kctx kubectx
    abbr -a kns kubens
    abbr -a kget kubectl get events --sort-by='.lastTimestamp'
    abbr -a kc kubectl config current-context
    abbr -a kde "kubectl get pods | grep Evicted | awk '{print $1}' | xargs -n 1 kubectl delete pod"
    abbr -a dsa "docker ps -aq | xargs docker stop | xargs docker rm"
    which lsd > /dev/null && alias ls lsd
end
