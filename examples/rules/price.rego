package rules.price

# Допустимый диапазон цен
min_price := 100
max_price := 1000

default keep := false

# Цена должна быть в диапазоне:
keep if {
    input.price >= min_price
    input.price <= max_price
}