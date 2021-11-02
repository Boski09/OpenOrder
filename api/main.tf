data "aws_region" "aws-region" {}
data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "api" {
  name =  var.api_name
  tags = var.tags
}

#/api
resource "aws_api_gateway_resource" "api_rsc_01" {
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "api"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1
resource "aws_api_gateway_resource" "api_rsc_02" {
  parent_id   = aws_api_gateway_resource.api_rsc_01.id
  path_part   = "v1"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1/createorder
resource "aws_api_gateway_resource" "api_rsc_03" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "createorder"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1/createorder/OPTIONS
resource "aws_api_gateway_method" "api_mthd_01" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_03.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_01" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_03.id
  http_method             = aws_api_gateway_method.api_mthd_01.http_method
  timeout_milliseconds    = 29000
  type                    = "MOCK"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mthd_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03.id
  http_method         = aws_api_gateway_method.api_mthd_01.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_mthd_01" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_03.id
  http_method         = aws_api_gateway_method.api_mthd_01.http_method
  status_code         = aws_api_gateway_method_response.api_mthd_01.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}

#/api/v1/createorder/POST
resource "aws_api_gateway_method" "api_mthd_02" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api_rsc_03.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_02" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_03.id
  http_method             = aws_api_gateway_method.api_mthd_02.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_02" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_03.id
  http_method     = aws_api_gateway_method.api_mthd_02.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_02" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_03.id
  http_method = aws_api_gateway_method.api_mthd_02.http_method
  status_code = aws_api_gateway_method_response.api_mthd_02.status_code
}


#/api/v1/getorderlist
resource "aws_api_gateway_resource" "api_rsc_04" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "getorderlist"
  rest_api_id = aws_api_gateway_rest_api.api.id
}

#/api/v1/getorderlist/OPTIONS
resource "aws_api_gateway_method" "api_mthd_03" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_04.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_03" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_04.id
  http_method             = aws_api_gateway_method.api_mthd_03.http_method
  timeout_milliseconds    = 29000
  type                    = "MOCK"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mthd_03" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_04.id
  http_method         = aws_api_gateway_method.api_mthd_03.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_mthd_03" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_04.id
  http_method         = aws_api_gateway_method.api_mthd_03.http_method
  status_code         = aws_api_gateway_method_response.api_mthd_03.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  } 
}

#/api/v1/getorderlist/GET
resource "aws_api_gateway_method" "api_mthd_04" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_rsc_04.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_04" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_04.id
  http_method             = aws_api_gateway_method.api_mthd_04.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_04" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_04.id
  http_method     = aws_api_gateway_method.api_mthd_04.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_04" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_04.id
  http_method = aws_api_gateway_method.api_mthd_04.http_method
  status_code = aws_api_gateway_method_response.api_mthd_04.status_code
  # response_parameters = { 
  #   "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
  #   "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
  #   "method.response.header.Access-Control-Allow-Origin" = "'*'"
  # } 
#   response_parameters_in_json = <<PARAMS
# {
#     "method.response.header.Access-Control-Allow-Origin": "'*'"
# }
# PARAMS
  response_templates = {
    "application/json" = <<EOF
{
  "a":"b",
  "c":"d",
  "e":"f"
}
EOF
  }

}


#/api/v1/orderlist
resource "aws_api_gateway_resource" "api_rsc_05" {
  parent_id   = aws_api_gateway_resource.api_rsc_02.id
  path_part   = "orderlist"
  rest_api_id = aws_api_gateway_rest_api.api.id
}


#/api/v1/getorderlist/GET
resource "aws_api_gateway_method" "api_mthd_05" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.api_rsc_05.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_05" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_05.id
  http_method             = aws_api_gateway_method.api_mthd_05.http_method
  type                    = "AWS_PROXY"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
  timeout_milliseconds    = 29000

}
resource "aws_api_gateway_method_response" "api_mthd_05" {
  rest_api_id     = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.api_rsc_05.id
  http_method     = aws_api_gateway_method.api_mthd_05.http_method
  status_code     = "200"
  response_models = {"application/json"="Empty"}
}
resource "aws_api_gateway_integration_response" "api_mthd_05" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_rsc_05.id
  http_method = aws_api_gateway_method.api_mthd_05.http_method
  status_code = aws_api_gateway_method_response.api_mthd_05.status_code
}


#/api/v1/orderlist/OPTIONS
resource "aws_api_gateway_method" "api_mthd_06" {
  authorization = "NONE"
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.api_rsc_05.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_integration" "api_mthd_06" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_rsc_05.id
  http_method             = aws_api_gateway_method.api_mthd_06.http_method
  timeout_milliseconds    = 29000
  type                    = "MOCK"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_method_response" "api_mthd_06" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05.id
  http_method         = aws_api_gateway_method.api_mthd_06.http_method
  status_code         = "200"
  response_models     = {"application/json"="Empty"}
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}
resource "aws_api_gateway_integration_response" "api_mthd_06" {
  rest_api_id         = aws_api_gateway_rest_api.api.id
  resource_id         = aws_api_gateway_resource.api_rsc_05.id
  http_method         = aws_api_gateway_method.api_mthd_06.http_method
  status_code         = aws_api_gateway_method_response.api_mthd_06.status_code
  response_parameters = { 
    "method.response.header.Access-Control-Allow-Headers" = "'pregma, cache-control, expires'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE, GET, HEAD, PATCH, PUT, POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}



#Lambda permission
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromApi"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.aws-region.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_mthd_02.http_method}${aws_api_gateway_resource.api_rsc_03.path}"
}

#API deployment
# resource "aws_api_gateway_deployment" "api_deployment" {
#   depends_on        = [aws_api_gateway_method.api_mthd_02]
#   rest_api_id       = aws_api_gateway_rest_api.api.id
#   description       = "Deployed at ${timestamp()}"
#   stage_name        = var.stage_name
#   stage_description = "Deployed at ${timestamp()}"
# }