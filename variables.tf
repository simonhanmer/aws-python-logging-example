variable "region" {
    type    = string
    default = "eu-west-2"
}

variable "log_group_retention" {
    type    = number
    default = 1
}

variable "project_name" {
    type    = string
    default = "lambda_logging"
}

variable "lambda_metric_namespace" {
    type = string
    default = "LambdaEvents"
}