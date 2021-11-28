FROM golang:alpine AS build-env
WORKDIR $GOPATH/src/github.com/ironcore864/k8s-security-demo
COPY . .
RUN apk add git
RUN go get ./... && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

FROM alpine
WORKDIR /app
COPY --from=build-env /go/src/github.com/ironcore864/k8s-security-demo/app /app/app
CMD ["./app"]

EXPOSE 8080/tcp
