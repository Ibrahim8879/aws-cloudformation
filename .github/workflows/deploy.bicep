name: Deploy Infrastructure

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write      # Required for OIDC authentication
  contents: read       # Required to read repo contents

env:
  AWS_REGION: ap-south-1  # Your AWS region
  OIDC_ARN: arn:aws:iam::350276938231:role/github-iac  # Your OIDC IAM role

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Configure AWS credentials via OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ env.OIDC_ARN }}
          aws-region: ${{ env.AWS_REGION }}

      - name: Create CloudFormation Stack
        run: |
          aws cloudformation create-stack \
            --stack-name test-s3bucket-demo \
            --template-url https://subucket.s3.us-west-1.amazonaws.com/S3-bucket.yaml
