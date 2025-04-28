package rules.checks

# 1. Параметры (чёрные списки) по умолчанию
default excluded_airlines           := []                            # default для полного определения :contentReference[oaicite:0]{index=0}
default excluded_primary_supp_codes := []

# Переопределяем, если переданы в input.params
excluded_airlines           := input.params.excluded_airlines   if input.params.excluded_airlines
excluded_primary_supp_codes := input.params.excluded_primary_supp_codes if input.params.excluded_primary_supp_codes

# 2. Предикаты для единичного билета
airline_blocked(ticket) = result if {
    result := ticket.airline_code in excluded_airlines          # membership “in” :contentReference[oaicite:1]{index=1}
}

supp_blocked(ticket) = result if {
    result := ticket.primary_supp_code in excluded_primary_supp_codes
}

# 3. Списки прошедших и проваленных проверок для билета
passed(ticket) = ps if {
    ps := array.concat(
        ["airline"      | not airline_blocked(ticket)],
        ["primary_supp" | not supp_blocked(ticket)]
    )                                                            # array.concat :contentReference[oaicite:2]{index=2}
}

failed(ticket) = fs if {
    fs := array.concat(
        ["airline"      | airline_blocked(ticket)],
        ["primary_supp" | supp_blocked(ticket)]
    )
}
