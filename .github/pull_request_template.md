## Изменение

Кратко опишите изменение и его границы.

Reason:

ASE impact:

## Трассировка

- Outcome ID:
- PDE handoff ID:
- Pack commit SHA:
- Product repository/PR:
- Delivery slice IDs:
- Definition Change, если требуется:

## Совместимость

- Control tag/SHA изменён: да/нет
- Contract version изменена: да/нет
- Breaking change: да/нет

## Проверка

- [ ] Выполнен `pwsh ./scripts/doctor.ps1`.
- [ ] Выполнен `pwsh ./scripts/validate-repository.ps1`.
- [ ] Входной и выходной handoff проверены, если применимо.
- [ ] Pack semantics не изменены внутри ASE.
- [ ] Код продукта, secrets и CI artifacts не добавлены в ASE repository.
- [ ] `vendor/engineering-control` не изменён вручную.

