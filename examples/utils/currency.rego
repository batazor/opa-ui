package utils.currency

convert_api_result := result if {
  result := currency.convert(input.price, input.from, input.to)
}
