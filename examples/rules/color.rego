package rules.color

# Разрешённые цвета
allowed_colors := {"black", "white", "silver"}

default keep := false

# Проходим, если цвет допустим
keep if input.color in allowed_colors