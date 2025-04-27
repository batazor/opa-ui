package rules.category

# Показываем только электронику и аксессуары
allowed_categories := {"electronics", "accessories"}

default keep := false
keep if input.category in allowed_categories
