```bash
# Set the current Redis server as a slave of the Redis server at address 127.0.0.1 and port 6379.
redis-cli SLAVEOF 127.0.0.1 6379

# Make the current Redis server stop being a slave of another server, i.e., change it from a slave to a master.
redis-cli SLAVEOF NO ONE

# Get the read-only setting of the current server. By default, slave servers are read-only.
redis-cli CONFIG GET slave-read-only

# Cancel the read-only setting of the current server, allowing it to perform write operations.
redis-cli CONFIG SET slave-read-only no

# Set the current server to read-only.
redis-cli CONFIG SET slave-read-only yes
```
