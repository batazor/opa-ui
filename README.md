# opa-ui

Rule engine for business policies

### Demo

```
# 1. Запускаем движок с новой папкой
opa run --server examples/

# 2. Валидный товар
curl -s -X POST localhost:8181/v1/data/flow/feed_selection_full/decision \
  -d '{
        "input": {
          "manufacturer":"Apple",  "color":"white", "price":799,
          "category":"electronics","weight_kg":1.2, "stock_qty":34,
          "discount_percent":20
        }}' | jq
        
{
  "result": {
    "failed": [],
    "keep": true,
    "passed": [
      "category",
      "color",
      "discount",
      "in_stock",
      "manufacturer",
      "price",
      "size"
    ]
  }
}

# 3. Невалидный товар (вне диапазона цены и нет на складе)
curl -s -X POST localhost:8181/v1/data/flow/feed_selection_full/decision \
  -d '{
        "input": {
          "manufacturer":"Sony",   "color":"black", "price":1500,
          "category":"electronics","weight_kg":1.0, "stock_qty":0,
          "discount_percent":15
        }}' | jq

{
  "result": {
    "failed": [
      "in_stock",
      "price"
    ],
    "keep": false,
    "passed": [
      "category",
      "color",
      "discount",
      "manufacturer",
      "size"
    ]
  }
}
```

#### Demo 2

```shell
curl -s -X POST localhost:8181/v1/data/flow/tickets_filter/results \
     -d @examples/fixtures/tickets_input.json | jq
```

```json
{
  "result": [
    {
      "failed": [
        "airline"
      ],
      "index": 0,
      "keep": false,
      "passed": [
        "primary_supp"
      ]
    },
    {
      "failed": [
        "primary_supp"
      ],
      "index": 1,
      "keep": false,
      "passed": [
        "airline"
      ]
    },
    {
      "failed": [],
      "index": 2,
      "keep": true,
      "passed": [
        "airline",
        "primary_supp"
      ]
    }
  ]
}
```

#### Demo 3

```shell
curl -s -X POST http://localhost:8181/v1/data/flow/apply_feed_filters/results \
     -d @examples/fixtures/feeds_input.json | jq
```

```json
{
  "result": [
    {
      "failed": [
        "upsells"
      ],
      "index": 0,
      "keep": false,
      "passed": [
        "airline",
        "priceType"
      ]
    },
    {
      "failed": [],
      "index": 1,
      "keep": true,
      "passed": [
        "airline",
        "priceType",
        "upsells"
      ]
    },
    {
      "failed": [
        "airline",
        "upsells"
      ],
      "index": 2,
      "keep": false,
      "passed": [
        "priceType"
      ]
    }
  ]
}
```

### Demo 4

```shell
curl -s -X POST http://localhost:8181/v1/data/flow/calculate_taxes/results \
     -d @examples/fixtures/tax_input.json | jq
```

```json
{
  "result": [
    {
      "index": 0,
      "reason": "matched_city",
      "tax": 0
    },
    {
      "index": 1,
      "reason": "matched_country",
      "tax": 10
    },
    {
      "index": 2,
      "reason": "matched_country",
      "tax": 15
    },
    {
      "index": 3,
      "reason": "default",
      "tax": 20
    }
  ]
}
```

### Test

```shell
opa test examples/ --verbose
```

```shell
examples/rules/tax_test.rego:
data.rules.tax_rules_test.test_calculate_tax_for_sochi: PASS (1.001544ms)

  ✔️ Checked RU/сочи: tax=0 reason=matched_city

data.rules.tax_rules_test.test_calculate_tax_for_moscow: PASS (593.441µs)

  ✔️ Checked RU/москва: tax=10 reason=matched_country

data.rules.tax_rules_test.test_calculate_tax_for_paris: PASS (610.128µs)

  ✔️ Checked FR/париж: tax=20 reason=default

--------------------------------------------------------------------------------
PASS: 3/3
```

### buildin: currency

```shell
curl -s -X POST "http://localhost:8181/v1/data/utils/currency/convert_api_result" \
  -H "Content-Type: application/json" \
  -d '{"input": {"price": 100, "from": "RUB", "to": "USD"}}' | jq
```

```json
{
  "result": 1.00
}
```