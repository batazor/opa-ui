# opa-ui

Rule engine for business policies

### Demo

```
# Запускаем OPA
opa run --server examples/

# --- товар, который проходит все фильтры ---
curl -s -X POST localhost:8181/v1/data/flow/feed_selection/decision \
     -d '{"input":{"manufacturer":"Apple","color":"black","price":450}}'
# {"result":{"keep":true,"passed":["manufacturer","color","price"],"failed":[]}}

# --- товар, который проваливает ценовой фильтр ---
curl -s -X POST localhost:8181/v1/data/flow/feed_selection/decision \
     -d '{"input":{"manufacturer":"Sony","color":"white","price":2000}}'
# {"result":{"keep":false,"passed":["manufacturer","color"],"failed":["price"]}}
```