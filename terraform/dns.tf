resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www.dpline.io"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.app.public_ip}"]
}
resource "aws_route53_zone" "main" {
  name = "www.dpline.io"
}