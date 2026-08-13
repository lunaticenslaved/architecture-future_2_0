# Task2Advanced — Terraform + CI/CD (Yandex Cloud)

Переиспользует общий модуль ВМ из `Task1Advanced/modules/vm` и добавляет удалённый S3-бэкенд + CI/CD.

## Структура
- `main.tf` — вызывает общий модуль ВМ
- `providers.tf` — провайдер + удалённый бэкенд `s3`
- `variables.tf` / `terraform.tfvars` — входные параметры (секреты через `TF_VAR_*`)
- `outputs.tf` — реэкспортированные выходные значения модуля
- `ci/terraform.yml` — пайплайн GitHub Actions

## Использование
```sh
export AWS_ACCESS_KEY_ID=...        # ключ для бакета состояния
export AWS_SECRET_ACCESS_KEY=...
cp backend.hcl.example backend.hcl  # заполните значения
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

Состояние хранится удалённо (никогда локально). Секреты берутся из переменных окружения / секретов CI, но никогда из репозитория.
