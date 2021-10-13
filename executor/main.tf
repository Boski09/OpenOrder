


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

module "api" {
    source = "../api"
    api_name   = "createorder"
    lambda_invoke_arn = module.lambda_function.lambda_function_invoke_arn
    lambda_name       = module.lambda_function.lambda_function_name
    stage_name        = "dev"
    tags              = var.tags
}