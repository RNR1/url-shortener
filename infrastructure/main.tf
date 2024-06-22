module "main" {
  source = "./modules/baseline-resources"

  env_name = "prod"
  domain   = "ronbraha.codes"
  app_slug = "url-shortener"
  app_name = "URL Shortener"

  # Override default variables below
}
