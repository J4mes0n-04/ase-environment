---
name: ase-accept-handoff
description: Проверяет PDE → ASE handoff и формирует обоснованный ACK до начала реализации.
---

# Приём PDE handoff

1. Прочитайте `config/control-plane.yaml` и входной JSON.
2. Запустите `scripts/validate-handoffs.ps1` для входа.
3. Проверьте Pack URL/SHA, risk, autonomy, slices, AC/NFR, границы и вопросы.
4. При любом блокирующем пробеле сформируйте `needs-clarification`.
5. При готовности заполните `templates/ase-ack.md` и зафиксируйте исполнителя/UTC.
6. Не исправляйте смысл входа внутри ASE.

