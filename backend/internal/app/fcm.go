package app

import (
	"context"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"google.golang.org/api/option"
)

type FCMClient struct {
	client *messaging.Client
}

func NewFCMClient(credentialsFile string) (*FCMClient, error) {
	opt := option.WithCredentialsFile(credentialsFile)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		return nil, err
	}

	client, err := app.Messaging(context.Background())
	if err != nil {
		return nil, err
	}

	return &FCMClient{client: client}, nil
}

func (f *FCMClient) SendBatch(ctx context.Context, tokens []string, title, body string, data map[string]string) []error {
	if len(tokens) == 0 {
		return nil
	}

	msg := &messaging.MulticastMessage{
		Tokens: tokens,
		Data:   data,
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
	}

	br, err := f.client.SendEachForMulticast(ctx, msg)
	if err != nil {
		errs := make([]error, len(tokens))
		for i := range errs {
			errs[i] = err
		}
		return errs
	}

	errs := make([]error, len(tokens))
	for i, resp := range br.Responses {
		if !resp.Success {
			errs[i] = resp.Error
		}
	}
	return errs
}