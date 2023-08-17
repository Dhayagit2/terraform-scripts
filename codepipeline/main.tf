
resource "aws_codestarconnections_connection" "example" {
  name          = var.connectionName
  provider_type = "GitHub"
}
resource "aws_codedeploy_app" "main" {
  name = var.applicationname
}
resource "aws_codedeploy_deployment_group" "main" {
  app_name              = "${aws_codedeploy_app.main.name}"
  deployment_group_name =  var.deploymentgroupname
  service_role_arn      = "arn:aws:iam::656983981950:role/codedeployrole"

  deployment_config_name = "CodeDeployDefault.OneAtATime" # AWS defined deployment config

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = var.NameOfinstancetodeploy
    }
    
  }

  # trigger a rollback on deployment failure event
  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }
}

resource "aws_codepipeline" "codepipeline" {
  name     = var.Pipelinename
  role_arn = "arn:aws:iam::656983981950:role/service-role/AWSCodePipelineServiceRole-ap-south-1-airace_webiste"

  artifact_store {
    location = "codepipeline-ap-south-1-649439418255"
    type     = "S3"
  encryption_key {
      type = "KMS"
      id = "alias/aws/s3"
    }
  } 

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = var.repositoryname
        BranchName       = var.branchname
      }
    }
  }

  
  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts  = ["source_output"]
    

      configuration = {
        ApplicationName          = aws_codedeploy_app.main.name # Replace with your CodeDeploy application name
        DeploymentGroupName      = aws_codedeploy_deployment_group.main.deployment_group_name
        
      }
    }
  }
}  
    
variable "connectionName" {
  description = "name for codestarconnectionname"
  
}
variable "applicationname" {
  description = "Name of the codepipeline's application"
  
}
variable "deploymentgroupname" {
  description = "name of the codedeploy application's deployment group"
}
variable "NameOfinstancetodeploy" {
  description = "name of the instance that should be deployed to"
}
variable "Pipelinename" {
  description = "Name of the pipeline"
}
variable "repositoryname" {
  description = "Name of the github repo"
}
variable "branchname" {
  description = "name of the branch"
}


