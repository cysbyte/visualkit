package processor

import "context"

type Job struct {
	ID             string
	ReferenceImage string
}

type Result struct {
	VisualDNA map[string][]string
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
	return "image_analysis"
}

func (Mock) Process(context.Context, Job) (Result, error) {
	return Result{
		VisualDNA: map[string][]string{
			"style":       {"Cinematic", "Editorial"},
			"lighting":    {"Soft Directional"},
			"color":       {"Warm", "Muted"},
			"composition": {"Centered"},
		},
	}, nil
}
