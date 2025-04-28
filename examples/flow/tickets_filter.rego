package flow.tickets_filter

###############################################################################
# 1. ПАРАМЕТРЫ (чёрные списки)
###############################################################################

# По умолчанию — пустые списки
default excluded_airlines           = []
default excluded_primary_supp_codes = []

# Переопределяем, если params переданы
excluded_airlines           = input.params.excluded_airlines
excluded_primary_supp_codes = input.params.excluded_primary_supp_codes

###############################################################################
# 2. РЕЗУЛЬТАТЫ ДЛЯ КАЖДОГО БИЛЕТА
###############################################################################

results = [res |
    some idx
    ticket := input.tickets[idx]

    # Проверяем блокировку
    airline_blocked := ticket.airline_code      in excluded_airlines
    supp_blocked    := ticket.primary_supp_code in excluded_primary_supp_codes

    # Собираем списки прошедших и проваленных проверок
    passed1 := ["airline"      | not airline_blocked]
    passed2 := ["primary_supp" | not supp_blocked]
    passed  := array.concat(passed1, passed2)

    failed1 := ["airline"      | airline_blocked]
    failed2 := ["primary_supp" | supp_blocked]
    failed  := array.concat(failed1, failed2)

    # Формируем объект-результат
    res := {
        "index":  idx,                 # позиция в исходном массиве
        "keep":   count(failed) == 0,  # true, если нет ни одного failed
        "passed": passed,
        "failed": failed,
    }
]
