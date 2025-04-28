package rules.feed_filters

# --- Параметры фильтров ---
default filter_airlines := []
default filter_price_types := []
default filter_upsell_airlines := []

filter_airlines := input.params.filter_airlines if input.params.filter_airlines
filter_price_types := input.params.pricing_ticketing.priceType if input.params.pricing_ticketing.priceType
filter_upsell_airlines := input.params.airlines_with_upsells if input.params.airlines_with_upsells

# --- Отдельные проверки ---

airline_allowed(item) if {
  item.airline in filter_airlines
}

price_allowed(item) if {
  item.pricing_ticketing.priceType in filter_price_types
}

upsell_allowed(item) if {
  item.airline in filter_upsell_airlines
}

# --- Сбор passed и failed (исправленный array.concat) ---

passed(item) := passed_filters if {
  passed_filters := array.concat(
    array.concat(
      [name | name := "airline"; airline_allowed(item)],
      [name | name := "priceType"; price_allowed(item)]
    ),
    [name | name := "upsells"; upsell_allowed(item)]
  )
}

failed(item) := failed_filters if {
  failed_filters := array.concat(
    array.concat(
      [name | name := "airline"; not airline_allowed(item)],
      [name | name := "priceType"; not price_allowed(item)]
    ),
    [name | name := "upsells"; not upsell_allowed(item)]
  )
}
