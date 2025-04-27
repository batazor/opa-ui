package rules.discount

# Если скидка > 50 %, скрываем товар — подозрительно
max_discount := 50        # %

default keep := false
keep if input.discount_percent <= max_discount
