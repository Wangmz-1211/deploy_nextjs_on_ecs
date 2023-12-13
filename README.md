Getting Started

### NPM

```bash
npm install
# AND
npm run dev
# OR
npm run build && npm run start

```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

### Docker

```shell
docker compose build
docker compose up -d
```

Open [http://localhost:80](http://localhost:80) with your browseer to see the result.

## Infrastructure

### Secrets for Github Action

AWS related

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_ACCOUNT_ID
- AWS_REGION

### Variables for Terraform

**Backend**: change the BUCKET_NAME and BUCKET_REGION to your own

:warning: The AWS Credential you configured in Github Action Secrets **must** has access to the bucket.

```hcl
  backend "s3" {
    bucket  = "BUCKET_NAME"
    key     = "terraform.tfstate"
    region  = "BUCKET-REGION"
    encrypt = false
  }
```
