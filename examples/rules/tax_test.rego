package rules.tax_rules_test

import data.rules.tax_rules

test_calculate_tax_with_city_match = true if {
    item := {
        "country": "RU",
        "city": "сочи"
    }

    params := {
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

    result := tax_rules.calculate_tax_with_reason(item) with input.params as params

    result.tax == 0
    result.reason == "matched_city"
}

test_calculate_tax_with_country_match = true if {
    item := {
        "country": "RU",
        "city": "москва"
    }

    params := {
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

    result := tax_rules.calculate_tax_with_reason(item) with input.params as params

    result.tax == 10
    result.reason == "matched_country"
}

test_calculate_tax_with_default = true if {
    item := {
        "country": "FR",
        "city": "париж"
    }

    params := {
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

    result := tax_rules.calculate_tax_with_reason(item) with input.params as params

    result.tax == 20
    result.reason == "default"
}
