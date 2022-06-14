#!/bin/bash
kubectl get nodes -o go-template='{{printf "%-39s %-12s\n" "Node" "Label"}}
{{- range .items}}
    {{- if $labels := (index .metadata.labels) }}
        {{- .metadata.name }}{{ "\t" }}
        {{- range $key, $value := $labels }}
            {{$key}}{{ "\t" }}{{$value}}
        {{- end }}
        {{- "\n" }}
    {{- end}}
{{- end}}'