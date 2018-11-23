import "github.com/go-redis/redis"

func main() {

    pubsub := redis.Subscribe("tglog")
	// Wait for confirmation that subscription is created before publishing anything.
	_, err := pubsub.Receive()
	if err != nil {
		panic(err)
	}

	// Go channel which receives messages.
	ch := pubsub.Channel()

	// Publish a message.
	//err = providers.KVR.Publish("mychannel1", "hello").Err()
	//if err != nil {
	//	panic(err)
	//}

	//time.AfterFunc(time.Second, func() {
	//	// When pubsub is closed channel is closed too.
	//	_ = pubsub.Close()
	//})

	// Consume messages.
	for msg := range ch {
		fmt.Println(msg.Channel, msg.Payload)
	}
}