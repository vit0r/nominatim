{{/*
Expand the name of the chart.
*/}}
{{- define "nominatim-db.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nominatim-db.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nominatim-db.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nominatim-db.labels" -}}
helm.sh/chart: {{ include "nominatim-db.chart" . }}
{{ include "nominatim-db.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nominatim-db.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nominatim-db.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nominatim-db.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nominatim-db.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
