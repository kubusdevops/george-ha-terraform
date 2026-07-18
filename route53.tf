# resource "aws_route53_record" "george_route53" {
#   zone_id = var.route53_zone_id
#   name    = "george-ha"
#   type    = "A"

#   alias {
#     name                   = aws_lb.george_lb.dns_name
#     zone_id                = aws_lb.george_lb.zone_id
#     evaluate_target_health = true
#   }
# }