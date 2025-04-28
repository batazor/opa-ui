package builtin

import (
	"time"

	"github.com/open-policy-agent/opa/ast"
	"github.com/open-policy-agent/opa/rego"
)

func futureNow(bctx rego.BuiltinContext, op1 *ast.Term) (*ast.Term, error) {
	now := time.Now().UTC().Format(time.RFC3339)
	return ast.StringTerm(now), nil
}
