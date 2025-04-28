package flow.tickets_filter

import data.rules.checks

###############################################################################
# Результаты обработки массива билетов
###############################################################################
results = [res |
    some idx
    ticket := input.tickets[idx]

    # вызываем вынесенные в rules/checks методы
    passed_list := checks.passed(ticket)
    failed_list := checks.failed(ticket)

    res := {
        "index":  idx,
        "keep":   count(failed_list) == 0,
        "passed": passed_list,
        "failed": failed_list,
    }
]
