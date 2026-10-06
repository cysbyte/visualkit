package queue

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/google/uuid"
)

type JobMessage struct {
	JobID   uuid.UUID `json:"job_id"`
	Type    string    `json:"type"`
	Attempt int       `json:"attempt"`
}

type JobQueue interface {
	Enqueue(ctx context.Context, message JobMessage) error
}

type ReceivedJobMessage struct {
	JobMessage
	ReceiptHandle string
}

type JobConsumer interface {
	Receive(ctx context.Context, maxMessages int, waitTime, visibilityTimeout time.Duration) ([]ReceivedJobMessage, error)
	Delete(ctx context.Context, receiptHandle string) error
}

// Publisher is retained as a compatibility alias for existing service wiring.
type Publisher interface {
	JobQueue
	Publish(message Message) error
}

type Message struct {
	JobID string
	Kind  string
}

type SQSConfig struct {
	QueueURL string
	Region   string
}

type SQSJobQueue struct {
	client   *sqs.Client
	queueURL string
}

func NewSQSJobQueue(ctx context.Context, configuration SQSConfig) (*SQSJobQueue, error) {
	if configuration.QueueURL == "" {
		return nil, errors.New("SQS queue URL is required")
	}
	if configuration.Region == "" {
		return nil, errors.New("SQS region is required")
	}
	awsConfiguration, err := awsconfig.LoadDefaultConfig(ctx, awsconfig.WithRegion(configuration.Region))
	if err != nil {
		return nil, fmt.Errorf("load AWS configuration: %w", err)
	}
	return &SQSJobQueue{
		client:   sqs.NewFromConfig(awsConfiguration),
		queueURL: configuration.QueueURL,
	}, nil
}

func (queue *SQSJobQueue) Enqueue(ctx context.Context, message JobMessage) error {
	if queue == nil || queue.client == nil {
		return errors.New("SQS queue is not initialized")
	}
	if message.JobID == uuid.Nil || message.Type == "" || message.Attempt < 1 {
		return errors.New("invalid job queue message")
	}
	body, err := json.Marshal(message)
	if err != nil {
		return fmt.Errorf("encode SQS job message: %w", err)
	}
	_, err = queue.client.SendMessage(ctx, &sqs.SendMessageInput{
		QueueUrl:    aws.String(queue.queueURL),
		MessageBody: aws.String(string(body)),
	})
	if err != nil {
		return fmt.Errorf("enqueue SQS job: %w", err)
	}
	return nil
}

func (queue *SQSJobQueue) Receive(
	ctx context.Context,
	maxMessages int,
	waitTime,
	visibilityTimeout time.Duration,
) ([]ReceivedJobMessage, error) {
	if queue == nil || queue.client == nil {
		return nil, errors.New("SQS queue is not initialized")
	}
	if maxMessages < 1 {
		maxMessages = 1
	}
	if maxMessages > 10 {
		maxMessages = 10
	}
	if waitTime < 0 {
		waitTime = 0
	}
	if waitTime > 20*time.Second {
		waitTime = 20 * time.Second
	}
	if visibilityTimeout < 0 {
		visibilityTimeout = 0
	}
	output, err := queue.client.ReceiveMessage(ctx, &sqs.ReceiveMessageInput{
		QueueUrl:            aws.String(queue.queueURL),
		MaxNumberOfMessages: int32(maxMessages),
		WaitTimeSeconds:     int32(waitTime / time.Second),
		VisibilityTimeout:   int32(visibilityTimeout / time.Second),
		MessageAttributeNames: []string{
			"All",
		},
	})
	if err != nil {
		return nil, fmt.Errorf("receive SQS jobs: %w", err)
	}
	messages := make([]ReceivedJobMessage, 0, len(output.Messages))
	for _, message := range output.Messages {
		if message.Body == nil || message.ReceiptHandle == nil {
			continue
		}
		var jobMessage JobMessage
		if err := json.Unmarshal([]byte(*message.Body), &jobMessage); err != nil {
			return nil, fmt.Errorf("decode SQS job message: %w", err)
		}
		if jobMessage.JobID == uuid.Nil || jobMessage.Type == "" || jobMessage.Attempt < 1 {
			return nil, errors.New("received invalid SQS job message")
		}
		messages = append(messages, ReceivedJobMessage{
			JobMessage:    jobMessage,
			ReceiptHandle: *message.ReceiptHandle,
		})
	}
	return messages, nil
}

func (queue *SQSJobQueue) Delete(ctx context.Context, receiptHandle string) error {
	if queue == nil || queue.client == nil {
		return errors.New("SQS queue is not initialized")
	}
	if receiptHandle == "" {
		return errors.New("SQS receipt handle is required")
	}
	_, err := queue.client.DeleteMessage(ctx, &sqs.DeleteMessageInput{
		QueueUrl:      aws.String(queue.queueURL),
		ReceiptHandle: aws.String(receiptHandle),
	})
	if err != nil {
		return fmt.Errorf("delete SQS job message: %w", err)
	}
	return nil
}

type MemoryPublisher struct {
	mu             sync.Mutex
	jobMessages    []JobMessage
	received       []ReceivedJobMessage
	deleted        map[string]bool
	legacyMessages []Message
}

func NewMemoryPublisher() *MemoryPublisher {
	return &MemoryPublisher{deleted: make(map[string]bool)}
}

func (publisher *MemoryPublisher) Enqueue(_ context.Context, message JobMessage) error {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	publisher.jobMessages = append(publisher.jobMessages, message)
	return nil
}

func (publisher *MemoryPublisher) Publish(message Message) error {
	jobID, err := uuid.Parse(message.JobID)
	if err != nil {
		publisher.mu.Lock()
		defer publisher.mu.Unlock()
		publisher.legacyMessages = append(publisher.legacyMessages, message)
		return nil
	}
	return publisher.Enqueue(context.Background(), JobMessage{
		JobID:   jobID,
		Type:    message.Kind,
		Attempt: 1,
	})
}

func (publisher *MemoryPublisher) Messages() []Message {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	messages := make([]Message, 0, len(publisher.jobMessages))
	messages = append(messages, publisher.legacyMessages...)
	for _, message := range publisher.jobMessages {
		messages = append(messages, Message{
			JobID: message.JobID.String(),
			Kind:  message.Type,
		})
	}
	return messages
}

func (publisher *MemoryPublisher) JobMessages() []JobMessage {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	return append([]JobMessage(nil), publisher.jobMessages...)
}

func (publisher *MemoryPublisher) Receive(
	_ context.Context,
	maxMessages int,
	_,
	_ time.Duration,
) ([]ReceivedJobMessage, error) {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	if maxMessages < 1 {
		maxMessages = 1
	}
	if len(publisher.received) == 0 && len(publisher.jobMessages) > 0 {
		for index, message := range publisher.jobMessages {
			publisher.received = append(publisher.received, ReceivedJobMessage{
				JobMessage:    message,
				ReceiptHandle: fmt.Sprintf("memory-%d", index),
			})
		}
		publisher.jobMessages = nil
	}
	count := maxMessages
	if count > len(publisher.received) {
		count = len(publisher.received)
	}
	messages := append([]ReceivedJobMessage(nil), publisher.received[:count]...)
	publisher.received = publisher.received[count:]
	return messages, nil
}

func (publisher *MemoryPublisher) Delete(_ context.Context, receiptHandle string) error {
	publisher.mu.Lock()
	defer publisher.mu.Unlock()
	if publisher.deleted == nil {
		publisher.deleted = make(map[string]bool)
	}
	publisher.deleted[receiptHandle] = true
	return nil
}
