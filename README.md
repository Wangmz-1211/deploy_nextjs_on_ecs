## Getting Started

### NPM

```bash
npm install

# AND

npm run dev
# OR
npm run build && npm run start

```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

### 🐳 Docker

```shell
docker compose build
docker compose up -d
```

Open [http://localhost:80](http://localhost:80) with your browseer to see the result.

## 🧱 Infrastructure

### 🗝️ Secrets for Github Action

AWS related

- `AWS_ACCESS_KEY_ID` (Create an IAM user and generate this)
- `AWS_SECRET_ACCESS_KEY` (Create an IAM user and generate this)
- `AWS_ACCOUNT_ID` (12-bit number)
- `AWS_REGION`
- `AWS_ECR_REPO` (This should be same to the `var.app_name` value you set in `./terraform/variable.tf`)

### Variables for Terraform

1. **Backend**: change the `BUCKET_NAME` and `BUCKET_REGION` to your own
   :warning: The AWS Credential you configured in Github Action Secrets **must** has access to the bucket.
   ```hcl
    backend "s3" {
        bucket  = "BUCKET_NAME"
        key     = "terraform.tfstate"
        region  = "BUCKET-REGION"
        encrypt = false
    }
   ```
2. **App name**: Change the value of the variable 'app-name' in `./terraform/variable.tf`, and keep the `secrets.AWS_ECR_REPO` in Github Action secrets same to that.
   ```hcl
   variable "app_name" {
       type    = string
       default = "my-devops-demo"
   }
   ```

## Workflows

### Terraform

```mermaid
graph TD
    Start((Start by:<br>- workflow_dispatch<br>- push/pr on infrastructure<br>- push/pr on stage )) ==> AWS[Setup AWS Credential] ==> TF[Setup Terraform]
    secret_AWS[[AWS_ACCESS_KEY_ID<br>AWS_SECRET_ACCESS_KEY]] --> AWS
    AWS --S3 access--> TF
    TF ==> Plan ==dispatch<br>or<br>on branch infrastructure==> Apply
    Plan == on branch stage==> Finish
    Apply ==> Finish((Finish))
```

### CI/CD

```mermaid
graph TD
	Start((Start by:<br>- workflow_dispatch<br>- push/pr on main))
	Start ==> Test
	subgraph Test
		eslint --> build
	end
	Test ==> Build
	subgraph Build
		AWS[Setup AWS Credential]
		secret_AWS[[AWS_ACCESS_KEY_ID<br>AWS_SECRET_ACCESS_KEY]] --> AWS
		AWS ==access==> ECR[Login to ECR]
		ECR ==> Docker[Build & Push]
		ECR_secret[[AWS_ACCOUT_ID<br>AWS_REGION<br>AWS_ECR_REPO]] --> Docker
	end
	Build ==> Deploy
	subgraph Deploy
		AWS_setup[Setup AWS Credential] ==> ECS[ECS service update]
		ECR_image[Image: app:latest] --> ECS
		ECR_sec[[AWS_ECR_REPO]] --> ECS
	end
```
