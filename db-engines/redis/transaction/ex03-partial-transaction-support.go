//go:build ignore

package main

import (
	"context"
	"fmt"

	"github.com/redis/go-redis/v9"
)

func main() {
	ctx := context.Background()

	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	_, err := rdb.Ping(ctx).Result()
	if err != nil {
		fmt.Println("Redis connection error:", err)
		return
	}

	rdb.Del(ctx, "foo1", "foo2")
	rdb.MSet(ctx, "foo1", "foo1", "foo2", "foo2")

	tx := rdb.TxPipeline()
	tx.Incr(ctx, "foo1")
	tx.Set(ctx, "foo2", "foo22", 0)
	cmds, err := tx.Exec(ctx)
	if err != nil {
		fmt.Println("Transaction execution failed:", err)
	} else {
		fmt.Println("Transaction executed successfully")
		for _, cmd := range cmds {
			fmt.Println(cmd.Name(), cmd.Args(), cmd.Err())
		}
	}

	values, err := rdb.MGet(ctx, "foo1", "foo2").Result()
	if err != nil {
		fmt.Println("Error getting values:", err)
	} else {
		fmt.Println("foo1:", values[0])
		fmt.Println("foo2:", values[1])
	}

	rdb.Close()
}
