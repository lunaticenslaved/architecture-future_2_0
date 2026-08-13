# Задание 4. Каталог доменных событий

События — контракт взаимодействия доменов на событийной магистрали Kafka (см. [`../Task3Advanced/diagrams/02-container-domains.puml`](../Task3Advanced/diagrams/02-container-domains.puml:1)). Каждый агрегат ([`aggregates.md`](aggregates.md:1)) публикует факт изменения; подписчики реагируют асинхронно.

## Конвенции
- **Имя:** `PascalCase`, прошедшее время (свершившийся факт). **Топик:** `snake_case` по домену/сущности (`clinics.patient.registered`).
- **Схема:** `schemaVersion` (semver) + subject в **Schema Registry**, совместимость **BACKWARD**.
- **Event key:** id корня агрегата — порядок событий на сущность. **Конверт:** `eventId`, `eventType`, `occurredAt`, `schemaVersion`, `producer`, `key`, `payload`.
- **Приватность:** медданные (медкарты/истории/результаты) в аналитические события **не** включаются — только метаданные/идентификаторы.

---

## Каталог событий

| Название (eventType) | Контекст-источник | Семантика (когда возникает) | Минимальный контракт (ключевые поля payload + **key**) | Основные подписчики |
| --- | --- | --- | --- | --- |
| `CreditContractCreated` | Финтех / Кредиты | Одобрен и создан кредитный договор | `contractId`, `customerId`, `amount`, `currency`, `termMonths`, `rate`; **key=contractId** | Биллинг, Кредитный риск, Аналитика, MDM |
| `LoanRepaymentReceived` | Финтех / Кредиты | Поступил платёж по погашению кредита | `contractId`, `paymentId`, `amount`, `paidAt`; **key=contractId** | Кредитный риск, Счета, Аналитика |
| `AccountOpened` | Финтех / Счета | Открыт банковский счёт | `accountId`, `customerId`, `currency`, `openedAt`; **key=accountId** | Биллинг, MDM, Аналитика |
| `PaymentProcessed` | Финтех / Счета | Платёж проведён по счёту | `paymentId`, `accountId`, `amount`, `currency`, `status`; **key=accountId** | Биллинг, Кредиты, Аналитика |
| `InvoiceIssued` | Финтех / Биллинг | Выставлен инвойс за услугу (клиника/ИИ) | `invoiceId`, `customerId`, `serviceRef`, `amount`; **key=invoiceId** | Счета/Платежи, Аналитика |
| `PatientRegistered` | Клиники / Регистрация | Зарегистрирован новый пациент | `patientId`, `masterCustomerId`, `consentRef`, `registeredAt`; **key=patientId** | Мед. ИИ, Биллинг, MDM, Аналитика |
| `AppointmentScheduled` | Клиники / Приёмы | Назначен приём/направление | `appointmentId`, `patientId`, `serviceCode`, `scheduledAt`; **key=patientId** | Мед. ИИ, Биллинг, Аналитика |
| `AiStudyRequested` | Медицинский ИИ | Создан запрос на ИИ-исследование | `studyId`, `patientRef`, `modelId`, `requestedAt`; **key=studyId** | Инференс-воркеры, Аналитика (метаданные) |
| `AiStudyCompleted` | Медицинский ИИ | ИИ-исследование завершено, есть результат | `studyId`, `patientRef`, `modelVersion`, `resultRef`, `confidence`; **key=studyId** | Клиники (Приёмы), Биллинг, Аналитика (без результата) |
| `DeviceRegistered` | Медтехника/IoT | Устройство зарегистрировано в реестре | `deviceId`, `serialNumber`, `firmwareVersion`; **key=deviceId** | Телеметрия, Аналитика |
| `DeviceTelemetryReceived` | Медтехника/IoT | Принято измерение телеметрии | `deviceId`, `readingId`, `metric`, `value`, `unit`, `ts`; **key=deviceId** | Клиники (алерты), Аналитика |
| `DrugShipmentDispatched` | Фарма / Поставки | Отгружена поставка препарата | `shipmentId`, `drugSku`, `batchId`, `quantity`, `dispatchedAt`; **key=shipmentId** | Клиники, Инвентарь (Корп.), Аналитика |
| `DrugShipmentDelivered` | Фарма / Поставки | Поставка доставлена | `shipmentId`, `deliveredAt`, `receivedBy`; **key=shipmentId** | Клиники, Инвентарь, Аналитика |
| `CustomerProfileUpdated` | Головной офис / MDM | Обновлён мастер-профиль клиента | `masterCustomerId`, `changedFields`, `profileVersion`; **key=masterCustomerId** | Клиники, Финтех, Фарма, Аналитика |
| `ConsentGranted` | IAM / Согласия | Предоставлено согласие на обработку | `consentId`, `subjectId`, `scope`, `grantedAt`; **key=subjectId** | Клиники, Мед. ИИ, Аналитика |

**Итого: 15 доменных событий** по 7 доменам + сквозной IAM. Обязательные примеры покрыты: `CreditContractCreated`, `PatientRegistered`, `AiStudyCompleted`.

---

## Schema Registry и DLQ
- **Schema Registry:** Avro-контракт на событие; продюсер валидирует payload, несовместимые изменения блокируются политикой BACKWARD.
- **DLQ:** невалидные/исчерпавшие ретраи сообщения → `<topic>.DLQ` с причиной — устойчивость без потери данных.
- **Идемпотентность:** дедупликация по `eventId`; ключ = id корня агрегата гарантирует порядок.

Имена событий согласованы с [`event-storming.md`](event-storming.md:1) и [`aggregates.md`](aggregates.md:1).
