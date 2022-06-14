# source 本脚本后使用
function ktaint(){
    kubectl get nodes -o go-template='{{printf "%-50s %-12s\n" "Node" "Taint"}}
    {{- range .items}}
        {{- if $taint := (index .spec "taints") }}
            {{- .metadata.name }}{{ "\t" }}
            {{- range $taint }}
                {{- .key }}={{ .value }}:{{ .effect }}{{ "\t" }}
            {{- end }}
            {{- "\n" }}
        {{- end}}
    {{- end}}'
}

function podCIDR(){
    kubectl get nodes -o go-template='{{- range .items}}{{ printf "name: %-20s, ip: %-15s, podCIDR: %-18s, creationTimestamp: %s\n" .metadata.name (index .status.addresses 0).address .spec.podCIDR .metadata.creationTimestamp}}{{- end}}'
}

function overlay_list(){
    for container in $(docker ps --all --quiet --format '{{ .Names }}'); do
        echo "$(docker inspect $container --format '{{.GraphDriver.Data.MergedDir }}' | sed -r 's#/merged##' ) = $container"
    done
}
