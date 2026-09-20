# План реализации ASE

- Outcome ID: `OUT-PSD-001`
- PDE handoff ID: `HOF-PDE-ASE-PSD-001`
- Pack commit SHA: `5fa996cf140a65109af3ccebd3848e1d7566745d`
- Product repository: `C:\Users\maksim\Documents\ChatGPT\PDE(home)\pixel-space-dodger` (локальный Git, ветка `main`)
- Delivery owner: ASE Owner

## Delivery slices

### SLICE-PSD-001 — играбельная партия первого среза

- Scope: отдельное окно, меню (Новая игра / Рекорды / Выход), автострельба, астероиды с ростом сложности, очки, Game Over, локальные top-5, чёрно-белая пиксельная графика, управление с клавиатуры.
- Зависимости: Edge или Chrome для режима `--app`; внешних npm-пакетов нет.
- Реализовано:
  - HTML Canvas + JavaScript;
  - запуск `start-game.cmd` / `start-game.ps1` → отдельное окно Chromium;
  - клавиши стрелки и WASD;
  - рекорды в `localStorage` (top-5);
  - автострельба по таймеру с ускорением вместе со сложностью.
- Критерий завершения: играбельная партия по AC/NFR; README запуска готов.

## Технические решения

1. Runtime: JavaScript в отдельном окне Edge/Chrome (`--app`).
2. Репозиторий продукта: `pixel-space-dodger` рядом с ASE environment (не внутри ASE).
3. Управление: стрелки + WASD, Enter/Esc в меню.
4. Автострельба: интервал от 0.28 с с уменьшением при росте сложности; лимит до 18 снарядов на экране.
5. Спрайты: пиксельный корабль, 3 формы астероидов, короткий снаряд, звёзды с параллаксом.
6. Рекорды: `localStorage` ключ `pixel-space-dodger.records.v1`.

## Тесты и доказательства

См. `evidence-map.md`. Метод: ручной прогон + запуск через `start-game.cmd`.

## Rollout и rollback

- Rollout: `start-game.cmd` на машине проверяющего.
- Stop conditions: не открывается окно; любой AC не выполняется.
- Rollback: `git checkout` предыдущего commit в продуктовом репозитории.

## Открытые вопросы

- `Q-001`: закрыт — локальный репозиторий `pixel-space-dodger`. Публикация на GitHub — отдельным шагом при необходимости.
- Изменение смысла Pack — только через PDE Definition Change.
