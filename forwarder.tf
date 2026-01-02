module "datadog_forwarder" {
  source  = "DataDog/log-lambda-forwarder-datadog/aws"
  version = "~> 1.0"

  # Parameters reference: https://docs.datadoghq.com/logs/guide/forwarder/?tab=manual#parameters
  dd_api_key = var.datadog_api_key
  dd_site    = var.datadog_site

  # Lambda function
  function_name         = "${var.prefix}-${var.uid}-datadog-forwarder"
  reserved_concurrency  = 10
  log_retention_in_days = 1
  dd_max_workers        = null   # (string)
  dd_enhanced_metrics   = false  # adds additional custom metrics used to inspect the Forwarder function's performance
  dd_log_level          = "WARN" # log level for the Forwarder function. DEBUG|INFO|WARN|ERROR|CRITICAL (default: "WARN")

  # Log forwarding
  dd_use_compression   = true
  dd_compression_level = 9
  # dd_multiline_log_regex_pattern = "\d{2}\/\d{2}\/\d{4}" # use to detect multi-line logs from S3 beginning with pattern “11/10/2014”
  dd_tags = join(",", [for k, v in var.datadog_tags : "${k}:${v}" if v != null]) # a comma-separated string of key:value pairs to tag the telemetry forwarded to Datadog.

  # Log scrubbing
  redact_email = false
  redact_ip    = false

  # Log filtering
  exclude_at_match = null # (string) regex

  # Advanced
  # dd_step_functions_trace_enabled = true #? verify is DISABLED by default

  # dd_store_failed_events          = true #? verify is DISABLED by default
  # dd_schedule_retry_failed_events = true #? verify is DISABLED by default

  # tag 'fetching' is done by the Forwarder during transmission (increasaes Forwarder overhead)
  # tag 'enrichment' is done by the Datadog backend
  dd_enrich_s3_tags = false #? verify is ENABLED by default, per docs? 
  # dd_enrich_cloudwatch_tags    = true #? verify is ENABLED by default, per docs? 
  # dd_fetch_lambda_tags         = false
  # dd_fetch_step_functions_tags = false

  tags = local.cloud_resource_tags # tag the supported AWS resources created by this module
}
