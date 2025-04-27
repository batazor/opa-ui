package flow.feed_selection_full

import data.rules.manufacturer
import data.rules.color
import data.rules.price
import data.rules.category
import data.rules.size
import data.rules.in_stock
import data.rules.discount

# 1. собираем статусы
status := {
  "manufacturer": manufacturer.keep,
  "color":        color.keep,
  "price":        price.keep,
  "category":     category.keep,
  "size":         size.keep,
  "in_stock":     in_stock.keep,
  "discount":     discount.keep,
}

# 2. списки пройденных / непрошедших
passed := [k | some k; status[k] == true]
failed := [k | some k; status[k] == false]

# 3. итог
keep := count(failed) == 0

decision := {
  "keep":   keep,
  "passed": passed,
  "failed": failed,
}
