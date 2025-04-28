package builtin

import (
	"github.com/open-policy-agent/opa/rego"
	"github.com/open-policy-agent/opa/types"
)

func RegisterBuiltins() {
	rego.RegisterBuiltin1(
		&rego.Function{
			Name: "future.now",
			Decl: types.NewFunction(types.Args(), types.S),
		},
		futureNow,
	)
	rego.RegisterBuiltin3(
		&rego.Function{
			Name: "currency.convert",
			Decl: types.NewFunction(types.Args(types.N, types.S, types.S), types.N),
		},
		currencyConvert,
	)
}
