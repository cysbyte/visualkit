FROM golang:1.22 AS build

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/visualkit-api ./cmd/api
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/visualkit-migrate ./cmd/migrate

FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=build /out/visualkit-api /app/visualkit-api
COPY --from=build /out/visualkit-migrate /app/visualkit-migrate
COPY --from=build /src/migrations /app/migrations

ENV MIGRATIONS_DIR=/app/migrations
EXPOSE 8080
ENTRYPOINT ["/app/visualkit-api"]
