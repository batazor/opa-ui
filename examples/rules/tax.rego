package rules.tax_rules

default default_tax := 20
default tax_mapping := {}

tax_mapping := input.params.tax_mapping if input.params.tax_mapping

# Единое правило с else-блоками
calculate_tax_with_reason(item) := {"tax": tax, "reason": "matched_city"} if {
    country := item.country
    city := lower(item.city)

    mapping := object.get(tax_mapping, country, {})

    city_tax := object.get(mapping, city, null)
    not city_tax == null

    tax := city_tax
} else := {"tax": tax, "reason": "matched_country"} if {
    country := item.country

    mapping := object.get(tax_mapping, country, {})

    country_tax := object.get(mapping, "*", null)
    not country_tax == null

    tax := country_tax
} else := {"tax": default_tax, "reason": "default"} if {
    true
}
