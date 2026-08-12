# Задание 1: Модульная инфраструктура для нескольких сред

Переиспользуемый Terraform-модуль ВМ для **Yandex Cloud** (`yandex_compute_instance`), применяемый в трёх средах (`dev`, `stage`, `prod`). Между средами различается только `terraform.tfvars` — сам модуль не содержит захардкоженных значений, специфичных для среды.

## Структура

```
Task1Advanced/
├── modules/vm/{main.tf,variables.tf,outputs.tf}   # переиспользуемая ВМ
└── envs/{dev,stage,prod}/{main.tf,variables.tf,providers.tf,terraform.tfvars}
```

## Параметры по средам

| Параметр      | dev         | stage       | prod        |
|---------------|-------------|-------------|-------------|
| cores         | 2           | 4           | 8           |
| memory (ГБ)   | 2           | 8           | 32          |
| core_fraction | 20          | 100         | 100         |
| disk_size (ГБ)| 20          | 50          | 200         |
| disk_type     | network-hdd | network-hdd | network-ssd |
| preemptible   | true        | false       | false       |
| nat           | true        | true        | false       |

## Предварительные требования

- Terraform `>= 1.3`.
- Аутентификация в Yandex Cloud (токен или ключ сервисного аккаунта).
- Замените каждый placeholder `*REPLACE_ME*` в целевом `terraform.tfvars` (`cloud_id`, `folder_id`, `subnet_id`, `image_id`, `ssh_public_key`).

## Развёртывание

Запускайте из каталога целевой среды (пример для `dev`):

```bash
cd Task1Advanced/envs/dev

# аутентификация: токен через переменную окружения либо задайте yc_service_account_key_file в tfvars
export TF_VAR_yc_token="$(yc iam create-token)"

terraform init
terraform apply -var-file=terraform.tfvars
```

Повторите для `stage` и `prod`, изменив каталог:

```bash
cd Task1Advanced/envs/stage && terraform init && terraform apply -var-file=terraform.tfvars
cd Task1Advanced/envs/prod  && terraform init && terraform apply -var-file=terraform.tfvars
```

Удаление ресурсов: `terraform destroy -var-file=terraform.tfvars`.
