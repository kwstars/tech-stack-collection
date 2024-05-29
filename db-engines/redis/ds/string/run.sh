#!/bin/bash

set -e
set -u
set -x
set -v

REDIS_CLI="docker exec -d redis redis-cli"

# Set the value of the key 'internal-encoding-int' to 8653 and get its internal encoding
$REDIS_CLI SET internal-encoding-int 8653
$REDIS_CLI OBJECT ENCODING internal-encoding-int

# Set the value of the key 'internal-encoding-embstr' to "hello" and get its internal encoding
$REDIS_CLI SET internal-encoding-embstr "hello"
$REDIS_CLI OBJECT ENCODING internal-encoding-embstr

# Set the value of the key 'internal-encoding-raw' to a string of 45 'x' characters and get its internal encoding
# https://github.com/redis/redis/blob/f35f36a265403c07b119830aa4bb3b7d71653ec9/src/object.c#L113-L125
$REDIS_CLI SET internal-encoding-raw "$(printf 'x%.0s' {1..45})"
$REDIS_CLI OBJECT ENCODING internal-encoding-raw

# https://redis.io/docs/latest/commands/?group=string
# Set the value of the key 'concurrency-cache-read' to 1 if it does not already exist
$REDIS_CLI SETNX concurrency-cache-read 1

# Set the value of the key 'concurrency-cache-write' to 1 only if it already exists
$REDIS_CLI SET concurrency-cache-write 1 XX

# Set the value of the key 'mykey' to "Hello, Redis!"
$REDIS_CLI SET mykey "Hello, Redis!"

# Set the value of the key 'mykey' to "Hello" only if it already exists
$REDIS_CLI SET mykey "Hello" XX

# Get the value of the key 'mykey'
$REDIS_CLI GET mykey

# Delete the key 'mykey'
$REDIS_CLI DEL mykey

# Append " How are you?" to the value of the key 'mykey'
$REDIS_CLI APPEND mykey " How are you?"

# Get the length of the value of the key 'mykey'
$REDIS_CLI STRLEN mykey

# Set the value of the key 'newkey' to "Hello, Redis!" if it does not already exist
$REDIS_CLI SETNX setnx-key "Hello, Redis!"

# Set the value of the key 'tempkey' to "This message will self-destruct in 60 seconds" and set its expiration time to 60 seconds
$REDIS_CLI SETEX setex-key 60 "This message will self-destruct in 60 seconds"

# Set the values of multiple keys
$REDIS_CLI MSET mset-key "Hello" key2 "Redis"

# Get the values of multiple keys
$REDIS_CLI MGET key1 key2

# Increment the value of the key 'counter' by 1
$REDIS_CLI INCR counter-1

# Decrement the value of the key 'counter' by 1
$REDIS_CLI DECR counter-1

# Increment the value of the key 'counter' by 5
$REDIS_CLI INCRBY counter-5 5

# Decrement the value of the key 'counter' by 5
$REDIS_CLI DECRBY counter-5 5
