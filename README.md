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

```
curl -s -X POST localhost:8181/v1/data/flow/tickets_filter/results \
     -d @examples/fixtures/tickets_input.json | jq
```

```
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