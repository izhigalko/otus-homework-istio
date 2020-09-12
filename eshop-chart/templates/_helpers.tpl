{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "eshop-chart.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eshop-chart.fullname" -}}
{{- $name := default .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Product search service fullname.
*/}}
{{- define "product-search-service.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "product-search-service" }}
{{- end }}

{{/*
Order service fullname.
*/}}
{{- define "order-service.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "order-service" }}
{{- end }}

{{/*
Delivery service fullname.
*/}}
{{- define "delivery-service.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "delivery-service" }}
{{- end }}

{{/*
Payment service fullname.
*/}}
{{- define "payment-service.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "payment-service" }}
{{- end }}

{{/*
Warehouse service fullname.
*/}}
{{- define "warehouse-service.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "warehouse-service" }}
{{- end }}

{{/*
Message broker fullname.
*/}}
{{- define "message-broker.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "message-broker" }}
{{- end }}

{{/*
Authorization server fullname.
*/}}
{{- define "auth-server.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "auth-server" }}
{{- end }}

{{/*
Gateway fullname.
*/}}
{{- define "gateway.fullname" -}}
{{- printf "%s-%s" (include "eshop-chart.fullname" .) "gateway" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eshop-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "eshop-chart.labels" -}}
helm.sh/chart: {{ include "eshop-chart.chart" . }}
{{ include "eshop-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Gateway common labels
*/}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "eshop-chart.chart" . }}
{{ include "gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Authorization server common labels
*/}}
{{- define "auth-server.labels" -}}
helm.sh/chart: {{ include "eshop-chart.chart" . }}
{{ include "auth-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Product search service common labels
*/}}
{{- define "product-search-service.labels" -}}
helm.sh/chart: {{ include "eshop-chart.chart" . }}
{{ include "product-search-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "eshop-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "eshop-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Gateway selector labels
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "gateway" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Authorization server selector labels
*/}}
{{- define "auth-server.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "auth-server" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Product search service selector labels
*/}}
{{- define "product-search-service.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "product-search-service" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Delivery service selector labels
*/}}
{{- define "delivery-service.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "delivery-service" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Order service selector labels
*/}}
{{- define "order-service.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "order-service" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Payment service selector labels
*/}}
{{- define "payment-service.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "payment-service" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Warehouse service selector labels
*/}}
{{- define "warehouse-service.selectorLabels" -}}
app.kubernetes.io/name: {{ printf "%s-%s" (include "eshop-chart.name" .) "warehouse-service" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Full product search service image name
*/}}
{{- define "product-search-service.fullImageName" -}}
{{- printf "%s:v%s" .Values.productSearchService.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full order service image name
*/}}
{{- define "order-service.fullImageName" -}}
{{- printf "%s:v%s" .Values.orderService.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full delivery service image name
*/}}
{{- define "delivery-service.fullImageName" -}}
{{- printf "%s:v%s" .Values.deliveryService.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full payment service image name
*/}}
{{- define "payment-service.fullImageName" -}}
{{- printf "%s:v%s" .Values.paymentService.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full warehouse service image name
*/}}
{{- define "warehouse-service.fullImageName" -}}
{{- printf "%s:v%s" .Values.warehouseService.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full api gateway image name
*/}}
{{- define "gateway.fullImageName" -}}
{{- printf "%s:v%s" .Values.apiGateway.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Full authorization server image name
*/}}
{{- define "auth-server.fullImageName" -}}
{{- printf "%s:v%s" .Values.authServer.image.repository .Chart.AppVersion }}
{{- end }}

{{/*
Annotation for config change detection
*/}}
{{- define "eshop-chart.configChangeDetection" -}}
{{- $secret := include (print $.Template.BasePath "/secret.yaml") . | sha256sum -}}
{{- $configmap := include (print $.Template.BasePath "/configmap.yaml") . | sha256sum -}}
checksum/config: {{ print $secret $configmap | sha256sum }}
{{- end }}

{{/*
Create postgresql fullname
*/}}
{{- define "eshop-chart.postgresqlFullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}