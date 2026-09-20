# Инструкции репозитория ASE

## Язык

- Человекочитаемые документы и рабочие артефакты пишите на русском языке.
- Имена файлов, JSON/YAML keys, код, enum values и устойчивые идентификаторы оставляйте на английском.
- При первом использовании сложного английского термина добавляйте понятное русское пояснение.

## Источники истины

- Общие нормы и contracts берите только из закреплённого `vendor/engineering-control`.
- Product Definition Pack берите по repository URL, path и полному commit SHA из PDE handoff.
- Реализацию выполняйте только в указанном продуктовом репозитории.
- Не копируйте Pack или код продукта в ASE repository.

## Границы ASE

- До реализации проверьте PDE → ASE contract и зафиксируйте ACK.
- При `needs-clarification` или блокирующем вопросе остановите реализацию и верните вопрос в PDE.
- Не меняйте scope, AC, NFR, риск, автономию или ожидаемый Outcome. Требуйте Definition Change.
- Технические решения допускаются только внутри `implementation_boundaries.ase_may_decide`.
- Каждый AC/NFR должен иметь test reference, evidence ID и результат.
- Не называйте работу готовой без полного implementation SHA, Evidence Bundle, release/rollback и ASE → QSRE handoff.

## Рабочие файлы

- Создавайте delivery только в `workspaces/projects/<project-id>/deliveries/<delivery-id>/`.
- Не размещайте реальные данные в `workspaces/examples/`.
- Не изменяйте `vendor/engineering-control` из ASE-задачи.
- Не смешивайте изменение платформы ASE и конкретный delivery в одном Pull Request.

## Инструменты

- OpenSpace работает только локально и не меняет governance автоматически.
- Не включайте внешние интеграции и облачную передачу без отдельного решения.
- Секреты храните только во внешнем secret store или переменных среды.

## Проверка

После изменения платформы выполните:

```powershell
pwsh ./scripts/doctor.ps1
pwsh ./scripts/validate-repository.ps1
```

После изменения handoff выполните:

```powershell
pwsh ./scripts/validate-handoffs.ps1 -PdeHandoffPath <input> -AseHandoffPath <output>
```

Сообщайте о неуспешной проверке и не обходите contract gate.

