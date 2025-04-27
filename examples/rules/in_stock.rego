package rules.in_stock

# Товар должен быть в наличии
default keep := false
keep if input.stock_qty > 0
