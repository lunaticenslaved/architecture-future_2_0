# Задание 3. Целевая архитектура «Будущее 2.0» (горизонт 3 года) — модель C4

## 1. Принципы целевой архитектуры

Переход от монолитного DWH (MS SQL Server 2008) к **слабосвязанной событийно-ориентированной платформе**. Legacy (Camel ESB, DWH) — временные ACL-мосты, выводятся к стадии 3.

- **Data Mesh** — каждый домен (Клиники, Финтех, Мед. ИИ, Фарма, Медтехника/IoT, Головной офис) владеет сервисами, топиками и данными как продуктом.
- **Событийная интеграция** — центральный backbone Apache Kafka + Schema Registry + DLQ; отказ от синхронных point-to-point на критическом пути.
- **Потоковая обработка** — Kafka Streams / Flink наполняют потоковые витрины (batch → near-real-time).
- **Self-service аналитика** — портал-витрина с семантическим слоем и RBAC/ABAC. Мед. карты, истории болезней, результаты исследований исключены из аналитического контура.
- **Облачная дата-платформа** — Lakehouse + аналитический DWH (ClickHouse) + каталог/governance/lineage; отдельная среда на домен, гео-распределение, соответствие ИБ и регуляторам.
- **ACL** — legacy DWH и Camel обёрнуты слоями Anti-Corruption Layer и помечены к выводу.

---

## 2. System Context (C4Context)

Диаграмма: [`diagrams/01-context.puml`](diagrams/01-context.puml:1)

Платформа — единая точка взаимодействия внутренних пользователей (операторы клиник, врачи, клиенты финтех, аналитики) и внешних участников (регуляторы, фарма-партнёры, производители медтехники). Новые направления подключаются как доменные наборы сервисов без центрального «узкого горла».

---

## 3. Container (C4Container)

Показано двумя диаграммами: (A) доменные сервисы и магистраль, (B) дата-платформа, витрина и сквозные сервисы.

### 3.A. Доменные сервисы, event backbone и legacy-мосты

Диаграмма: [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1)

Доменные сервисы (Клиники, Финтех, Мед. ИИ, Фарма, IoT-медтехника, Корпоративный) публикуют события в центральную магистраль Kafka (Schema Registry + DLQ + Flink). Новые бизнес-направления — Фарма и IoT-медтехника — добавляются как самостоятельные домены. Legacy-мосты (CDC/Debezium, ACL над DWH и Camel) временно интегрируют MS SQL Server 2008 и Apache Camel ESB и выводятся к стадии 3.

### 3.B. Дата-платформа, self-service витрина и сквозные сервисы

Диаграмма: [`diagrams/03-container-dataplatform.puml`](diagrams/03-container-dataplatform.puml:1)

Облачная дата-платформа (Lakehouse + ClickHouse + потоковые витрины + каталог/lineage) наполняется из Flink, а self-service витрина с семантическим слоем и IAM (RBAC/ABAC) отдаёт отчёты аналитикам и регуляторам. Ключевое: **Power Builder** → доменные UI + портал; **Power BI**-кастомизации → семантический слой (dbt/Cube.dev); **Legacy DWH/Camel** → ACL + CDC (мосты, вывод к стадии 3); мед. карты/истории/исследования не попадают в аналитический контур (фильтрация на уровне доменных сервисов и governance).

---

## 4. Component (C4Component)

### 4.1. Self-service витрина данных

Диаграмма: [`diagrams/04-component-portal.puml`](diagrams/04-component-portal.puml:1)

API Gateway + авторизация (RBAC/ABAC) — пользователь видит только доступные срезы. Семантический слой отделяет метрики от физической модели ClickHouse; query engine + кэш дают производительность; аудит в Kafka закрывает требования ИБ. Мед. карты/истории/исследования к порталу не подключаются.

### 4.2. Пилотный домен Финтех

Диаграмма: [`diagrams/05-component-fintech.puml`](diagrams/05-component-fintech.puml:1)

Пилот вводит единые событийные принципы: схемо-валидируемые события (Schema Registry), потребители расчётов/риска на потоках, ошибки → DLQ с повторами, ACL-адаптер изолирует legacy DWH на период миграции.

---

## 5. Масштабирование: 3 оси × 3 стадии

**3 оси:**
- **Продукты** — новое направление = новый доменный набор сервисов + топики + схемы; монетизируемые ИИ-сервисы — отдельный домен-продукт. Центрального «узкого горла» нет.
- **География** — отдельная облачная среда на регион, data residency, локальные регуляторные политики; единые принципы backbone/схем при региональной изоляции ПДн.
- **Данные** — новые источники через CDC + коннекторы + Schema Registry; сдвиг от батча к потоковым витринам (Flink → materialized views → ClickHouse); каталог/lineage управляют ростом.

**3 стадии** — диаграмма: [`diagrams/06-stages.puml`](diagrams/06-stages.puml:1)

| Стадия | Горизонт | Ключевые действия | Роль legacy |
| --- | --- | --- | --- |
| 1 | 0–6 мес | Пилот в 1–2 доменах (финрасчёты или поток пациентов); событийные принципы, DLQ, реестр схем | DWH и Camel — основные источники, читаются через CDC |
| 2 | 6–18 мес | Расширение на критические домены, запуск потоковых витрин, ввод ACL для Camel/DWH | DWH и Camel демотированы до ACL-мостов |
| 3 | 18–36 мес | Отказ от синхронных point-to-point на критическом пути, доменная аналитика на потоках | DWH и Camel выводятся из эксплуатации |

**Изменение систем при росте:**
- **Новые направления** — новый домен = сервисы + топики + схемы; контракты в Registry, события в Kafka, витрины через Flink; без зависимости от DWH.
- **Новые источники** — через CDC (Debezium)/коннекторы, схема в Registry, данные в Lakehouse и витрины; каталог фиксирует lineage.
- **Вывод legacy** — DWH/Camel → ACL-мосты (стадия 2) → вывод (стадия 3). Критерии: все отчёты на портале/ClickHouse, домены не обращаются к DWH напрямую, CDC не требуется.

---

## 6. Соответствие требований задания и диаграмм

Задание: «Спроектируйте целевую архитектуру системы «Будущего 2.0» в горизонте трёх лет, используя C4-модель на уровне контейнеров и компонентов. Покажите, как изменятся ключевые системы компании при масштабировании, включая появление новых бизнес-направлений, интеграцию дополнительных источников данных и отказ от легаси-систем.»

| Требование | Где показано (диаграмма/раздел) | Как выполнено (кратко) |
| --- | --- | --- |
| Целевая архитектура на горизонт 3 лет | [`diagrams/06-stages.puml`](diagrams/06-stages.puml:1); разделы 1, 5, 6 | Три стадии 0–6 / 6–18 / 18–36 мес и общий нарратив принципов целевого состояния |
| C4-модель на уровне **контейнеров** | [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1), [`diagrams/03-container-dataplatform.puml`](diagrams/03-container-dataplatform.puml:1); раздел 3 | Container-диаграммы (A) доменные сервисы + backbone и (B) дата-платформа + витрина + сквозные сервисы |
| C4-модель на уровне **компонентов** | [`diagrams/04-component-portal.puml`](diagrams/04-component-portal.puml:1), [`diagrams/05-component-fintech.puml`](diagrams/05-component-fintech.puml:1); раздел 4 | Component-диаграммы портала-витрины и пилотного домена Финтех |
| Контекст системы (C4Context) | [`diagrams/01-context.puml`](diagrams/01-context.puml:1); раздел 2 | Внутренние пользователи и внешние участники, единая точка взаимодействия |
| Изменение ключевых систем при масштабировании | Раздел 5 (3 оси × 3 стадии); [`diagrams/06-stages.puml`](diagrams/06-stages.puml:1) + container-диаграммы | Оси продуктов/географии/данных на трёх стадиях; переход batch → потоковые витрины |
| Появление новых бизнес-направлений (Фарма, Медтехника/IoT) | [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1); разделы 3.A, 5 | Новые домены Фарма и IoT Gateway медтехники как отдельные наборы сервисов + топики + схемы |
| Интеграция дополнительных источников данных (CDC, коннекторы, Schema Registry) | [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1), [`diagrams/03-container-dataplatform.puml`](diagrams/03-container-dataplatform.puml:1); разделы 3, 5 | CDC/Debezium, Schema Registry, коннекторы витрин, Lakehouse и каталог/lineage |
| Отказ от легаси-систем (DWH SQL 2008, Camel ESB) | [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1), [`diagrams/05-component-fintech.puml`](diagrams/05-component-fintech.puml:1); раздел 5 (стадии) | ACL-мосты над DWH/Camel + CDC → демотирование (стадия 2) → вывод (стадия 3) |
| Отказ от легаси-инструментов (Power Builder, Power BI) | [`diagrams/03-container-dataplatform.puml`](diagrams/03-container-dataplatform.puml:1); раздел 3.B | Power Builder → доменные UI + портал; кастомизации Power BI → семантический слой (dbt/Cube.dev) |

---

## 7. Итоговые решения

- Событийная магистраль Kafka + Schema Registry + DLQ — основа слабой связности.
- Data Mesh: доменное владение сервисами, топиками и данными-продуктами.
- Потоковая обработка (Flink) и потоковые витрины для near-real-time.
- Self-service портал с семантическим слоем и RBAC/ABAC; исключение мед. карт/историй/исследований.
- Облачная дата-платформа: Lakehouse + ClickHouse + каталог/lineage.
- Legacy (DWH, Camel) — временные ACL-мосты с CDC, вывод к стадии 3.
- Масштабирование по осям продуктов, географии и данных без центрального «узкого горла».

---

## 8. Диаграммы (standalone-файлы)

Все диаграммы вынесены в отдельные файлы PlantUML в каталоге [`diagrams/`](diagrams/):

- C4 Context → [`diagrams/01-context.puml`](diagrams/01-context.puml:1)
- Container (доменные сервисы + event backbone) → [`diagrams/02-container-domains.puml`](diagrams/02-container-domains.puml:1)
- Container (облачная дата-платформа + витрина) → [`diagrams/03-container-dataplatform.puml`](diagrams/03-container-dataplatform.puml:1)
- Component (портал-витрина) → [`diagrams/04-component-portal.puml`](diagrams/04-component-portal.puml:1)
- Component (пилотный домен Финтех) → [`diagrams/05-component-fintech.puml`](diagrams/05-component-fintech.puml:1)
- Стадии трансформации → [`diagrams/06-stages.puml`](diagrams/06-stages.puml:1)
