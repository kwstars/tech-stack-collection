package main

import (
	"context"
	"fmt"
	"strconv"
	"sync"
	"time"

	"github.com/redis/go-redis/v9"
)

func main() {
	rdb1, err := createRedisClient("localhost:6379", "", 0)
	if err != nil {
		fmt.Println("Redis connection error:", err)
		return
	}
	defer rdb1.Close()

	rdb2, err := createRedisClient("localhost:6379", "", 0)
	if err != nil {
		fmt.Println("Redis connection error:", err)
		return
	}
	defer rdb2.Close()

	rdb1.Del(context.Background(), "balance", "debt")
	rdb1.MSet(context.Background(), "balance", 100, "debt", 0)

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		client1(rdb1)
	}()

	go func() {
		defer wg.Done()
		client2(rdb2)
	}()

	wg.Wait()
}

func createRedisClient(addr, password string, db int) (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: password,
		DB:       db,
	})

	_, err := rdb.Ping(context.Background()).Result()
	if err != nil {
		return nil, err
	}

	return rdb, nil
}

func client1(rdb *redis.Client) {
	ctx := context.Background()

	const maxRetries = 3
	const retryDelay = time.Millisecond * 100 // 重试间隔

	for i := 0; i < maxRetries; i++ {
		err := rdb.Watch(ctx, func(tx *redis.Tx) error {
			// 1. 获取当前余额
			balanceStr, err := tx.Get(ctx, "balance").Result()
			if err != nil && err != redis.Nil {
				return err
			}

			var balance int64
			if balanceStr != "" { // 检查是否为空字符串
				balance, err = strconv.ParseInt(balanceStr, 10, 64)
				if err != nil {
					return err
				}
			}

			// 2. 检查余额是否足够
			if balance < 20 {
				return fmt.Errorf("insufficient balance")
			}

			// 3. 执行事务操作
			_, err = tx.Pipelined(ctx, func(pipe redis.Pipeliner) error {
				pipe.DecrBy(ctx, "balance", 20)
				pipe.IncrBy(ctx, "debt", 20)
				return nil
			})
			return err
		}, "balance")

		if err == nil {
			fmt.Println("client1 transaction successful")
			return
		}

		if err == redis.TxFailedErr {
			// 乐观锁冲突，稍后重试
			fmt.Println("client1 transaction failed, retrying...")
			time.Sleep(retryDelay)
			continue
		}

		fmt.Println("client1 transaction error:", err)
		return
	}

	fmt.Println("client1 transaction failed after retries")
}

func client2(rdb *redis.Client) {
	ctx := context.Background()

	balance, err := rdb.Get(ctx, "balance").Result()
	if err != nil {
		fmt.Println("client2 error:", err)
		return
	}
	fmt.Println("client2 get balance:", balance)

	err = rdb.Set(ctx, "balance", 800, 0).Err()
	if err != nil {
		fmt.Println("client2 error:", err)
		return
	}

	balance, err = rdb.Get(ctx, "balance").Result()
	if err != nil {
		fmt.Println("client2 error:", err)
		return
	}

	fmt.Println("client2 get balance:", balance)
}
