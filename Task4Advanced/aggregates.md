# Задание 4. Ключевые агрегаты по доменам

Агрегат — **граница согласованности** и **источник доменных событий**. Внутри границы изменения атомарны и защищают инварианты; между агрегатами — eventual consistency через события ([`events.md`](events.md:1)). Идентификатор корня = ключ партиционирования событий. Контексты: [`bounded-contexts.md`](bounded-contexts.md:1).

| Агрегат / Домен | Root · Ключ | Граница | Инварианты | Value Objects | События |
| --- | --- | --- | --- | --- | --- |
| **Кредитный договор** · Финтех | `CreditContract` · `contractId` | Договор + график + транши | Сумма > 0 и ≤ лимита; график = тело + %; переходы `Draft→Active→Closed/Defaulted`; активация только по одобренному риску | `Money`, `InterestRate`, `RepaymentSchedule`, `Term` | `CreditContractCreated`, `LoanRepaymentReceived` |
| **Пациент/Регистрация** · Клиники | `PatientRegistration` · `patientId` | Регистрация + эпизод (EMR отдельно) | Уникальность в MDM; нужен активный `Consent`; назначение — только в активном эпизоде | `FullName`, `ContactInfo`, `InsurancePolicy`, `ConsentRef` | `PatientRegistered`, `AppointmentScheduled` |
| **Исследование ИИ** · Мед. ИИ | `AiStudy` · `studyId` | Запрос + инференс + результат | Результат неизменяем; `confidence∈[0,1]`; только версия модели из каталога; медданные не покидают домен | `ModelVersion`, `StudyResult`, `StudyStatus` | `AiStudyRequested`, `AiStudyCompleted` |
| **Счёт/Платёж** · Финтех | `Account` · `accountId` | Счёт + баланс + платежи | Баланс ≥ лимита; платёж идемпотентен по `paymentId`; согласованность суммы/валюты | `Money`, `AccountStatus`, `TransactionRef` | `AccountOpened`, `PaymentProcessed`, `InvoiceIssued` |
| **Устройство/Телеметрия** · IoT | `Device` · `deviceId` | Реестр устройства; телеметрия — поток по `deviceId` | Регистрация до телеметрии; измерение в диапазоне датчика; алерт при выходе за порог | `SerialNumber`, `Measurement`, `Threshold` | `DeviceRegistered`, `DeviceTelemetryReceived` |
| **Поставка препарата** · Фарма | `DrugShipment` · `shipmentId` | Заказ + позиции + статус | Кол-во > 0; нельзя доставить непринятое; партия не просрочена; `Dispatched→InTransit→Delivered` | `Sku`, `Batch`, `Quantity`, `ShipmentStatus` | `DrugShipmentDispatched`, `DrugShipmentDelivered` |
| **Профиль клиента (MDM)** · Головной офис | `CustomerProfile` · `masterCustomerId` | «Золотая запись» + связи доменных id | Уникальность после дедупликации; версия при изменении ПДн; связывание — только по подтверждённому сопоставлению | `PersonName`, `Identifier`, `Address`, `ProfileVersion` | `CustomerProfileUpdated`, `ConsentGranted` |

> Каждый агрегат автономно валидирует инварианты и публикует факт изменения как событие, на которое подписываются другие домены — слабая связность вместо синхронных вызовов.
