package flow.apply_feed_filters

import data.rules.feed_filters

results := [r |
  some i
  item := input.feeds[i]

  ps := feed_filters.passed(item)
  fs := feed_filters.failed(item)

  r := {
    "index":  i,
    "keep":   count(fs) == 0,
    "passed": ps,
    "failed": fs,
  }
]
