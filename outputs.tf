# Output Declarations
#
#----------------------------------
output "Guacamole-Server-HTTPS-Address" {
  description = "The HTTPS URL Address for the Guacamole Server."
  value       = "https://${aws_eip.guacamole-server-eip.public_ip}/guacamole/"
}

output "Guacamole-Server-HTTP-Tomcat-Address" {
  description = "The HTTP URL Address (Tomcat) for the Guacamole Server."
  value       = "http://${aws_eip.guacamole-server-eip.public_ip}:8080/guacamole/"
}

output "Guacamole-Login-Password" {
  description = "The login password for Guacamole."
  value       = local.guac_pass
}

output "Guacamole-Login-Username" {
  description = "The login username for Guacamole."
  value       = "admin"
}

output "Ubuntu-Redirector-Server-IP" {
  description = "The IP address for the Ubuntu Redirector Server."
  value       = aws_eip.redirector-server-eip.public_ip
}
