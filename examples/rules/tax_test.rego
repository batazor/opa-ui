package rules.tax_rules_test

import data.rules.tax_rules

# Служебные данные — НЕ тесты, поэтому имя без префикса test_
default cases_data := [
  {
    "input": {"country":"RU","city":"сочи"},
    "expected_tax": 0,
    "expected_reason": "matched_city"
  },
  {
    "input": {"country":"RU","city":"москва"},
    "expected_tax": 10,
    "expected_reason": "matched_country"
  },
  {
    "input": {"country":"FR","city":"париж"},
    "expected_tax": 20,
    "expected_reason": "default"
  }
]

default params_data := {
  "tax_mapping": {
    "RU": {
      "сочи": 0,
      "*": 10
    },
    "DE": {
      "*": 15
    }
  }
}

# 1) Сочи
test_calculate_tax_for_sochi = true if {
  item := {"country":"RU","city":"сочи"}
  result := tax_rules.calculate_tax_with_reason(item) with input.params as params_data

  result.tax == 0
  result.reason == "matched_city"
  print(sprintf("✔️ Checked %s/%s: tax=%v reason=%s",
    [item.country, item.city, result.tax, result.reason]))
}

# 2) Москва
test_calculate_tax_for_moscow = true if {
  item := {"country":"RU","city":"москва"}
  result := tax_rules.calculate_tax_with_reason(item) with input.params as params_data

  result.tax == 10
  result.reason == "matched_country"
  print(sprintf("✔️ Checked %s/%s: tax=%v reason=%s",
    [item.country, item.city, result.tax, result.reason]))
}

# 3) Париж (дефолт)
test_calculate_tax_for_paris = true if {
  item := {"country":"FR","city":"париж"}
  result := tax_rules.calculate_tax_with_reason(item) with input.params as params_data

  result.tax == 20
  result.reason == "default"
  print(sprintf("✔️ Checked %s/%s: tax=%v reason=%s",
    [item.country, item.city, result.tax, result.reason]))
}
