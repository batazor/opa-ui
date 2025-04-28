package builtin

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
	"github.com/pkg/errors"
)

var exchangeRates = map[string]map[string]float64{
	"RUB": {
		"USD": 0.01,
		"EUR": 0.009,
	},
	"USD": {
		"RUB": 100.0,
		"EUR": 0.95,
	},
	"EUR": {
		"RUB": 110.0,
		"USD": 1.05,
	},
}

func currencyConvert(bctx rego.BuiltinContext, priceTerm, fromTerm, toTerm *ast.Term) (*ast.Term, error) {
	priceNum, ok := priceTerm.Value.(ast.Number)
	if !ok {
		return nil, errors.New("first argument must be a number")
	}
	fromStr, ok := fromTerm.Value.(ast.String)
	if !ok {
		return nil, errors.New("second argument must be a string")
	}
	toStr, ok := toTerm.Value.(ast.String)
	if !ok {
		return nil, errors.New("third argument must be a string")
	}

	price, err := strconv.ParseFloat(string(priceNum), 64)
	if err != nil {
		return nil, errors.Wrap(err, "failed to parse price")
	}

	from := strings.ToUpper(string(fromStr))
	to := strings.ToUpper(string(toStr))

	// if currencies are the same — no conversion
	if from == to {
		return ast.NumberTerm(json.Number(fmt.Sprintf("%.2f", price))), nil
	}

	ratesFrom, ok := exchangeRates[from]
	if !ok {
		return nil, fmt.Errorf("unsupported source currency: %s", from)
	}

	rate, ok := ratesFrom[to]
	if !ok {
		return nil, fmt.Errorf("unsupported target currency: %s", to)
	}

	converted := price * rate

	return ast.NumberTerm(json.Number(fmt.Sprintf("%.2f", converted))), nil
}
