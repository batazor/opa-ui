package flow.feed_selection

import data.rules.manufacturer
import data.rules.color
import data.rules.price

#
# 1. Результаты частных фильтров
#
status := {
  "manufacturer": manufacturer.keep,
  "color":        color.keep,
  "price":        price.keep,
}

#
# 2. Какие фильтры прошли / не прошли
#
passed := [k |                      # берём ключи, где значение true
           some k
           status[k] == true]

failed := [k |                      # берём ключи, где значение false
           some k
           status[k] == false]

#
# 3. Итоговое решение
#
keep := count(failed) == 0

#
# 4. Структура ответа
#
decision := {
  "keep":   keep,
  "passed": passed,
  "failed": failed,
}
