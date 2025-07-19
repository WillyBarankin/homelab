{{- define "photoprism.name" -}}
photoprism
{{- end -}}

{{- define "photoprism.fullname" -}}
{{ include "photoprism.name" . }}
{{- end -}} 