# Task2Advanced — Terraform + CI/CD (Yandex Cloud)

Reuses the shared VM module from `Task1Advanced/modules/vm` and adds a remote S3 backend + CI/CD.

## Layout
- `main.tf` — invokes the shared VM module
- `providers.tf` — provider + remote `s3` backend
- `variables.tf` / `terraform.tfvars` — inputs (secrets via `TF_VAR_*`)
- `outputs.tf` — re-exported module outputs
- `ci/terraform.yml` — GitHub Actions pipeline

## Usage
```sh
export AWS_ACCESS_KEY_ID=...        # state bucket key
export AWS_SECRET_ACCESS_KEY=...
cp backend.hcl.example backend.hcl  # fill in values
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

State is stored remotely (never local). Secrets come from env vars / CI secrets, never the repo.
