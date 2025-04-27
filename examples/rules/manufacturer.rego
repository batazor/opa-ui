package rules.manufacturer

# Разрешённые производители
allowed_makers := {"Apple", "Samsung", "Sony"}

default keep := false

# Товар проходит, если его производитель в white-list
keep if input.manufacturer in allowed_makers