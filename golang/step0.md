Клонируем репозиторий и переходим в проект: 

`git clone https://github.com/webngt/literate-spork && cd literate-spork`{{execute}}

запустим линтер

`golangci-lint run ./...`{{execute}}

запустим тесты

`go test ./...`{{execute}}

запустим билд:

`GOOS=linux go build -ldflags="-w -s" -o main cmd/app/main.go`{{execute}}

запустим приложение:

`./main`{{execute}}