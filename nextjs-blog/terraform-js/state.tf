terraform {
    backend "s3" {
        bucket = "nextjs-my-terraform-state"
        key = "global/s3/terraform.tfstate"
        region = "eu-central-1"
        dynamodb_table = "terraform-lock-file"
    }
}