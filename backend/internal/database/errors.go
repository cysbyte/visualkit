package database

import "errors"

var ErrNotFound = errors.New("not found")

var ErrInsufficientCredits = errors.New("insufficient credits")
