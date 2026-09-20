# Внесение изменений

1. Обновите `main` и submodules.
2. Создайте отдельную ветку `delivery/`, `platform/`, `skill/` или `integration/`.
3. Не смешивайте delivery и платформенное изменение.
4. Запустите `doctor.ps1`, `validate-repository.ps1` и применимые handoff checks.
5. Проверьте отсутствие secrets и изменений внутри `vendor/engineering-control`.
6. Откройте Pull Request и дождитесь обязательных проверок.

Изменение control tag/SHA, contracts, scripts, rules, skills или CI требует явного описания причины и влияния на совместимость.

