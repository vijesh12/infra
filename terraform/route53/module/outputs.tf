output "findcovidtestingcom_ns" {
  description = "findcovidtestingcom NS"
  value       = var.environment == "production" ? aws_route53_zone.findcovidtestingcom[0].name_servers : []
}
output "findcovid19testingorg_ns" {
  description = "findcovid19testingorg NS"
  value       = var.environment == "production" ? aws_route53_zone.findcovid19testingorg[0].name_servers : []
}
