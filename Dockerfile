FROM golang:1.16.3 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main main.go
########----------------------------############
FROM alpine:latest

RUN apk --no-cache add tzdata
RUN apk --no-cache add ca-certificates

ENV TZ=Asia/Bangkok

WORKDIR /root/

COPY --from=builder /app/main .
EXPOSE 3000
CMD ["./main"]
