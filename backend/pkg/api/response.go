package api

import (
	"encoding/json"
	"errors"
	"net/http"
	"strings"

	"github.com/visualkit/backend/internal/database"
)

type Envelope struct {
	Data  any        `json:"data"`
	Error *ErrorBody `json:"error"`
}

type ErrorBody struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

var (
	ErrInvalidRequest      = errors.New("invalid request")
	ErrUnauthorized        = errors.New("unauthorized")
	ErrInvalidCredentials  = errors.New("invalid credentials")
	ErrUnavailable         = errors.New("dependency unavailable")
	ErrQueueFailure        = errors.New("queue failure")
	ErrInsufficientCredits = errors.New("insufficient credits")
)

func WriteData(response http.ResponseWriter, status int, data any) {
	Write(response, status, Envelope{Data: data, Error: nil})
}

func WriteError(response http.ResponseWriter, err error) {
	status := http.StatusInternalServerError
	code := "INTERNAL_ERROR"
	message := "An unexpected error occurred."

	switch {
	case errors.Is(err, ErrInvalidRequest):
		status = http.StatusBadRequest
		code = "INVALID_REQUEST"
		message = err.Error()
	case errors.Is(err, ErrUnauthorized):
		status = http.StatusUnauthorized
		code = "UNAUTHORIZED"
		message = "Authentication is required."
	case errors.Is(err, ErrInvalidCredentials):
		status = http.StatusUnauthorized
		code = "INVALID_CREDENTIALS"
		message = "The supplied credentials are invalid."
	case errors.Is(err, ErrUnavailable):
		status = http.StatusServiceUnavailable
		code = "SERVICE_UNAVAILABLE"
		message = "A required service is unavailable."
	case errors.Is(err, ErrQueueFailure):
		status = http.StatusServiceUnavailable
		code = "QUEUE_UNAVAILABLE"
		message = "The job could not be queued."
	case errors.Is(err, ErrInsufficientCredits):
		status = http.StatusPaymentRequired
		code = "INSUFFICIENT_CREDITS"
		message = "There are not enough credits for this generation."
	case errors.Is(err, database.ErrNotFound):
		status = http.StatusNotFound
		code = "NOT_FOUND"
		message = "The requested resource was not found."
	default:
		if strings.HasPrefix(err.Error(), "invalid request: ") {
			status = http.StatusBadRequest
			code = "INVALID_REQUEST"
			message = strings.TrimPrefix(err.Error(), "invalid request: ")
		}
	}

	Write(response, status, Envelope{
		Data:  nil,
		Error: &ErrorBody{Code: code, Message: message},
	})
}

func Write(response http.ResponseWriter, status int, value Envelope) {
	response.Header().Set("Content-Type", "application/json")
	response.WriteHeader(status)
	_ = json.NewEncoder(response).Encode(value)
}
