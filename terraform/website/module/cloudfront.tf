resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "website"
}

locals {
  s3_origin_id  = "website"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "website CF"
  default_root_object = var.default_root_object

  aliases = var.use_alias ? var.cloudfront_aliases : []

  default_cache_behavior {
    allowed_methods  = ["GET", "DELETE", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      locations = [
        "BR",
        "CN",
        "CO",
        "DE",
        "IN",
        "KR",
        "LT",
        "RU",
        "VE",
      ]
      restriction_type = "blacklist"
    }
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = var.price_class

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
  }
}