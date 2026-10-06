package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/visualkit/image-analysis-worker/internal/processor"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	log.Printf("visualkit image-analysis worker started; kind=%s", processor.NewMock().Kind())
	<-ctx.Done()
	log.Println("visualkit image-analysis worker stopped")
}
