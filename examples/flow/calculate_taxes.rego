package flow.calculate_taxes

import data.rules.tax_rules

results := [r |
  some i
  item := input.taxs[i]

  tax_info := tax_rules.calculate_tax_with_reason(item)

  r := {
    "index": i,
    "tax": tax_info.tax,
    "reason": tax_info.reason
  }
]
