package main

import (
	"context"
	"log"

	"github.com/open-policy-agent/opa/runtime"

	"github.com/batazor/opa-ui/internal/builtin"
)

func main() {
	builtin.RegisterBuiltins()

	ctx := context.Background()

	params := runtime.Params{
		Paths:  []string{"./examples"}, // Путь к твоим rego и json
		Watch:  true,                   // Автоматическая перезагрузка при изменении файлов
		Output: log.Writer(),           // Вывод логов в консоль
		Addrs:  &[]string{":8181"},     // Адрес, на котором будет запущен сервер
	}

	rt, err := runtime.NewRuntime(ctx, params)
	if err != nil {
		panic(err)
	}

	err = rt.Serve(ctx)
	if err != nil {
		panic(err)
	}
}
