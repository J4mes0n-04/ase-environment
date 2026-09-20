# Runbook передачи PDE → ASE → QSRE

## Приём от PDE

1. Получить `pde-to-ase.json`.
2. Провалидировать Schema v1.0.0.
3. Проверить доступность Pack по конкретному SHA.
4. Сверить Outcome ID, Pack version, risk, autonomy, slices, AC/NFR и ограничения.
5. Проверить, что блокирующих открытых вопросов нет.
6. Записать ACK. При пробеле вернуть `needs-clarification` и конкретные вопросы.

## Реализация

1. Создать технический план в разрешённых границах.
2. Связать каждый commit/PR с Outcome и delivery slice.
3. Создать тесты и evidence для каждого AC/NFR.
4. Зафиксировать ограничения и остаточные риски.
5. Подготовить rollout, stop conditions и rollback.

Если требуется изменить смысл Pack, остановить затронутую работу и запросить Definition Change в PDE.

## Передача в QSRE

1. Сформировать `ase-to-qsre.json`.
2. Указать полный implementation SHA и Pull Request URLs.
3. Заполнить coverage каждого AC/NFR.
4. Приложить immutable Evidence Bundle и release plan.
5. Выполнить contract validation.
6. Передать QSRE и дождаться ACK.

После ручной проверки цепочки можно запустить workflow `notify-qsre-evidence`. Он создаёт Issue в QSRE и не объединяет Pull Request.

