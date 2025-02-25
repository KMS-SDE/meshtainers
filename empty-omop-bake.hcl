group "default" {
  targets = ["vocabs", "cdm", "omop"]
}

target "vocabs" {
  context = "./pipeline_containers/prep_vocabs"
  dockerfile = "Dockerfile"
  tags = ["meshtainer/kms_vocabs:latest"]
  secret = [
    { type = "file", id = "ulms_api_key", src = "ulms_api_key" },
  ]

}

target "cdm" {
  context = "./data_containers/cdm_postgres"
  dockerfile = "Dockerfile"
  secret = [
    { type = "file", id = "postgres_password", src = "postgres_password" },
  ]
  tags = ["meshtainer/cdm_postgres:latest"]
}

target "omop" {
  context = "./data_containers/omop_postgres"
  contexts = {
      cdm_image = "target:cdm"
      vocabs_image = "target:vocabs"
  }

  dockerfile = "Dockerfile"
  secret = [
    { type = "file", id = "postgres_password", src = "postgres_password" },
  ]
  tags = ["meshtainer/omop_postgres:latest"]
}
