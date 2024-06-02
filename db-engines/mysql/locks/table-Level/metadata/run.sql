-- Create a table 'inventory' with two columns 'product_id' and 'quantity'
CREATE TABLE inventory (
  product_id INT PRIMARY KEY,
  quantity INT NOT NULL
);

-- Insert some data into the 'inventory' table
INSERT INTO inventory (product_id, quantity)
VALUES (123, 100);

INSERT INTO inventory (product_id, quantity)
VALUES (124, 200);

INSERT INTO inventory (product_id, quantity)
VALUES (125, 300);

-- Acquire an exclusive lock on the 'inventory' table
LOCK TABLES inventory WRITE;

-- Acquire an exclusive lock on the 'inventory' table
UPDATE inventory
SET quantity = quantity - 5
WHERE product_id = 123;

-- Release the lock
UNLOCK TABLES;

SHOW PROCESSLIST;

/*
 +-----+-----------------+--------------------+--------+---------+-------+---------------------------------+-------------------------+
 | Id  | User            | Host               | db     | Command | Time  | State                           | Info                    |
 +-----+-----------------+--------------------+--------+---------+-------+---------------------------------+-------------------------+
 | 5   | event_scheduler | localhost          | <null> | Daemon  | 21224 | Waiting on empty queue          | <null>                  |
 | 9   | root            | 192.168.16.1:49388 | test   | Sleep   | 19650 |                                 | <null>                  |
 | 668 | root            | 192.168.16.1:39046 | test   | Query   | 0     | init                            | show processlist        |
 | 802 | root            | 192.168.16.1:57500 | test   | Sleep   | 2     |                                 | <null>                  |
 | 803 | root            | 192.168.16.1:57516 | test   | Query   | 2     | Waiting for table metadata lock | SELECT * FROM inventory |
 +-----+-----------------+--------------------+--------+---------+-------+---------------------------------+-------------------------+
 */
SELECT blocking_pid
FROM sys.schema_table_lock_waits;

/*
 +--------------+
 | blocking_pid |
 +--------------+
 | 811          |
 +--------------+
 */
