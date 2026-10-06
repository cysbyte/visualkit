package processor

import "context"

type Job struct {
	ID              string
	GenerationInput string
}

type Result struct {
	OutputImageReference string
	ThumbnailReference   string
}

type Processor interface {
	Kind() string
	Process(context.Context, Job) (Result, error)
}

type Mock struct{}

func NewMock() Mock {
	return Mock{}
}

func (Mock) Kind() string {
	return "image_generation"
}

func (Mock) Process(context.Context, Job) (Result, error) {
	return Result{
		OutputImageReference: "mock://visualkit/generated-image",
		ThumbnailReference:   "mock://visualkit/generated-thumbnail",
	}, nil
}
