# ASE operating environment

Этот репозиторий — рабочая среда **ASE (Agentic Software Engineering)**. ASE принимает утверждённое определение продукта от PDE, реализует его в отдельном репозитории продукта, собирает технические доказательства и передаёт результат в QSRE для независимой проверки.

> **Статус:** `0.1.0-shadow`. Среда является каркасом для shadow pilot, не production-контуром. Общая основа закреплена на `engineering-control v1.0.0-rc.1`; она остаётся `staging`, `authoritative: false`, а контракты — `draft`.

## Граница ответственности

ASE отвечает за:

- приём и проверку PDE → ASE handoff;
- явный ACK: `accepted`, `rejected` или `needs-clarification`;
- технический план и реализацию согласованных delivery slices;
- связь Pack SHA, Pull Request и implementation SHA;
- карту AC/NFR → tests/evidence;
- release contribution, rollback и остаточный риск;
- формирование ASE → QSRE handoff.

ASE не имеет права самостоятельно менять Outcome, scope, AC, NFR, риск или смысл Pack. Для этого возвращается запрос в PDE и создаётся Definition Change.

## Архитектура

```text
engineering-control v1.0.0-rc.1 (read-only submodule)
                         |
PDE Pack + handoff ------v
                   ASE intake
                         |
                 ACK / clarification
                         |
                 product repository
                 code + tests + PR
                         |
                 evidence + release
                         |
                 ASE -> QSRE handoff
```

Код продукта не хранится в этом репозитории. В `workspaces/projects/` находятся только ASE delivery records и ссылки на неизменяемые версии внешних артефактов.

## Быстрый старт

Клонируйте вместе с общей основой:

```powershell
git clone --recurse-submodules <ase-repository-url>
Set-Location ase-environment
pwsh ./scripts/doctor.ps1
pwsh ./scripts/validate-repository.ps1
pwsh ./scripts/validate-handoffs.ps1
```

Если репозиторий уже клонирован без submodule:

```powershell
git submodule update --init --recursive
```

## Рабочий поток

1. Создайте `workspaces/projects/<project-id>/deliveries/<delivery-id>/`.
2. Сохраните входной `pde-to-ase.json` без изменения смысла.
3. Выполните `pwsh ./scripts/validate-handoffs.ps1 -PdeHandoffPath <path>`.
4. Проверьте Pack URL, полный SHA, риск, автономию, slices, AC/NFR, ограничения, telemetry и expected evidence.
5. Заполните `ase-ack.md`. Не начинайте реализацию при блокирующих вопросах.
6. Реализуйте изменение в отдельном продуктовом репозитории через Pull Request.
7. Сформируйте `implementation-plan.md`, `evidence-map.md` и `ase-to-qsre.json`.
8. Проверьте входной и выходной contracts одной командой.
9. Передайте QSRE ссылки на Pack SHA, implementation SHA, evidence и release plan.

Подробный процесс: [operations/handoff-runbook.md](operations/handoff-runbook.md).

## Общая нормативная основа

Параметры pin находятся в [config/control-plane.yaml](config/control-plane.yaml):

- tag: `v1.0.0-rc.1`;
- commit: `abd0982171341438cab80267099b951a2027be0b`;
- contracts: `1.0.0`;
- mode: `shadow`.

Submodule `vendor/engineering-control` считается read-only. Любое обновление tag/SHA выполняется отдельным Pull Request после compatibility checks.

## Межрепозиторные уведомления

Пока pin остаётся `v1.0.0-rc.1`, ASE не вызывает reusable workflows из `engineering-control`. Локальный `validate-ase.yml` остаётся обязательной проверкой.

Ручные события:

- `listen-pde-ready.yml` — Issue о готовности Pack со стороны PDE;
- `notify-qsre-evidence.yml` — Issue в QSRE о готовности evidence.

Оба workflow запускаются только через `workflow_dispatch`. Они не принимают ACK, не меняют Pack и не объединяют Pull Request. Для `notify-qsre-evidence` нужны секреты GitHub App в Environment `notify-qsre`.

## Дополнительные инструменты

OpenSpace, Unleash, OpenTelemetry и Grafana выключены. Их наличие в `config/features.yaml` не означает установку. Включение выполняется отдельным изменением после назначения владельца, настройки подключения и проверки безопасности.

## Основные каталоги

- `architecture/` — границы и устройство ASE;
- `config/` — pin общей основы и feature flags;
- `templates/` — русскоязычные рабочие шаблоны;
- `scripts/` — doctor и validators;
- `operations/` — запуск и рабочий процесс;
- `workspaces/projects/` — delivery records, но не код продукта;
- `.agents/skills/` — ASE-specific skills;
- `vendor/engineering-control/` — неизменяемая общая основа.

