# Структура ASE-репозитория

- `vendor/engineering-control/` — закреплённая read-only общая основа;
- `config/` — версия среды, contracts и feature flags;
- `architecture/` — границы среды;
- `operations/` — рабочие инструкции;
- `templates/` — шаблоны ASE records;
- `workspaces/projects/` — delivery records и ссылки;
- `.agents/skills/` и `.cursor/rules/` — ASE-specific поведение агентов;
- `scripts/` и `.github/` — автоматические gates.

Код продукта, полный PDE workspace и QSRE records в этот репозиторий не копируются.

