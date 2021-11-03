data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}


module "dynamodb" {
  source                = "../dynamodb"
  # project               = var.project
  # env                   = "${terraform.workspace}"
  # region                = data.aws_region.aws-region.name
  dynamodb_table_name   = "Orders"
  dynamo_billing_mode   = "PROVISIONED"
  dynamo_write_capacity = 5
  dynamo_read_capacity  = 10
  hash_key              = "id"
  hash_key_type         = "S"
  range_key             = "name"
  range_key_type        = "N"
  tags                  = var.tags
}

module "lambda_function" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CreateOrder"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}

module "api_lambda_function_authorizer" {
  source   = "../lambda"
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.lambda_subnet_ids
  lambda_function_name           = "CreateOrderAPIAuthorizer"
  #The valid format for lambda_handler_name for dotnetcore3.1 is 'ASSEMBLY::TYPE::METHOD'
  lambda_handler_name            = "LambdaFunction::LambdaFunction.LambdaHandler::handleRequest"
  lambda_function_runtime        = var.lambda_function_runtime
  lambda_max_memory              = var.lambda_max_memory
  lambda_timeout                 = var.lambda_timeout
  lambda_deployment_package_path = "../lambda/lambda_function.zip"
  lambda_env_variables           = {}
  publish_lambda                 = true
  tags                           = var.tags
}


module "api" {
    source = "../api"
    api_name   = "createorder"
    lambda_invoke_arn = module.lambda_function.lambda_function_invoke_arn
    lambda_name       = module.lambda_function.lambda_function_name
    authorizer_lambda_invoke_arn = module.api_lambda_function_authorizer.lambda_function_invoke_arn
    stage_name        = "dev"
    tags              = var.tags
}