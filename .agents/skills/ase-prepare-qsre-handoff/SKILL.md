---
name: ase-prepare-qsre-handoff
description: Формирует и проверяет ASE → QSRE handoff по общей contract Schema.
---

# Передача в QSRE

1. Проверьте завершённость реализации и evidence map.
2. Создайте JSON по `vendor/engineering-control/contracts/ase-to-qsre.schema.json`.
3. Укажите Pack SHA, implementation SHA, PR URLs и delivery slices.
4. Покройте каждый AC/NFR.
5. Добавьте limitations, release, rollback, residual risks и contacts.
6. Запустите `scripts/validate-handoffs.ps1` для входа и выхода.
7. Передайте QSRE только прошедший проверку файл.

