# Системный контекст ASE

ASE находится между PDE и QSRE. Входом служит валидный PDE → ASE handoff со ссылкой на Pack baseline. Реализация живёт в отдельном продуктовом репозитории. Выходом служит ASE → QSRE handoff со ссылками на implementation commit, evidence, release и rollback.

`engineering-control` задаёт общий смысл contracts, но не хранит операционное состояние ASE. ASE не изменяет Pack и не принимает решение о продуктовом результате.

