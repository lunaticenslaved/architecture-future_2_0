# Задание 1: Модульная инфраструктура для нескольких сред

Reusable Terraform VM module for **Yandex Cloud** (`yandex_compute_instance`) reused across three environments (`dev`, `stage`, `prod`). Only `terraform.tfvars` differs between environments — the module contains no hardcoded environment values.

## Layout

```
Task1Advanced/
├── modules/vm/{main.tf,variables.tf,outputs.tf}   # the reusable VM
└── envs/{dev,stage,prod}/{main.tf,variables.tf,providers.tf,terraform.tfvars}
```

## Per-environment sizing

| Setting       | dev         | stage       | prod        |
|---------------|-------------|-------------|-------------|
| cores         | 2           | 4           | 8           |
| memory (GB)   | 2           | 8           | 32          |
| core_fraction | 20          | 100         | 100         |
| disk_size (GB)| 20          | 50          | 200         |
| disk_type     | network-hdd | network-hdd | network-ssd |
| preemptible   | true        | false       | false       |
| nat           | true        | true        | false       |

## Prerequisites

- Terraform `>= 1.3`.
- Yandex Cloud auth (token or service account key).
- Replace every `*REPLACE_ME*` placeholder in the target `terraform.tfvars` (`cloud_id`, `folder_id`, `subnet_id`, `image_id`, `ssh_public_key`).

## Deployment

Run from inside the target environment directory (example for `dev`):

```bash
cd Task1Advanced/envs/dev

# auth: token via env var, or set yc_service_account_key_file in tfvars
export TF_VAR_yc_token="$(yc iam create-token)"

terraform init
terraform apply -var-file=terraform.tfvars
```

Repeat for `stage` and `prod` by changing the directory:

```bash
cd Task1Advanced/envs/stage && terraform init && terraform apply -var-file=terraform.tfvars
cd Task1Advanced/envs/prod  && terraform init && terraform apply -var-file=terraform.tfvars
```

Tear down: `terraform destroy -var-file=terraform.tfvars`.
