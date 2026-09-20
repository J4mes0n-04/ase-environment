---
name: ase-plan-implementation
description: Создаёт технический план реализации принятого delivery slice без изменения Product Definition Pack.
---

# План реализации

1. Убедитесь, что ACK имеет статус `accepted`.
2. Используйте `templates/implementation-plan.md`.
3. Ограничьте решения списком `ase_may_decide`.
4. Свяжите каждый slice и requirement с кодом, тестом и evidence method.
5. Добавьте dependencies, rollout, stop conditions и rollback.
6. Смысловое изменение верните в PDE как Definition Change.

