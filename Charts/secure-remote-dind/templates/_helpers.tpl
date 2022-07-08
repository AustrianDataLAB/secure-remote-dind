{{/*
Expand the name of the chart.
*/}}
{{- define "secureremotedind.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "secureremotedind.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 46 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 46 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 46 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "secureremotedind.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 46 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "secureremotedind.labels" -}}
helm.sh/chart: {{ include "secureremotedind.chart" . }}
{{ include "secureremotedind.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "secureremotedind.selectorLabels" -}}
app.kubernetes.io/name: {{ include "secureremotedind.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "secureremotedind.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "secureremotedind.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the IP of the CoreDNS service
*/}}
{{ define "dnsServiceIP" }}
{{- range $index, $service := (lookup "v1" "Service" "kube-system" "").items -}}
  {{- if hasKey $service.metadata.labels "kubernetes.io/name" -}}
    {{- range $index, $label := $service.metadata.labels -}}
      {{- if eq $label "CoreDNS" -}}
        {{- $service.spec.clusterIP -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{ end }}

{{/*
Create the imagePullSecret of the deployment to use
*/}}
{{- define "imagePullSecret" -}}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc -}}
{{- end -}}