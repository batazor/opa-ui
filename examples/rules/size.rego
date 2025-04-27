package rules.size

# Продаём товары, у которых размер упаковки не более 1.5 кг
max_weight := 1.5        # кг

default keep := false
keep if input.weight_kg <= max_weight
