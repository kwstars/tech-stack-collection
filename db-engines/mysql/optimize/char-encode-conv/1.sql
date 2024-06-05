CREATE TABLE tradelog (
  id INT(11) NOT NULL,
  tradeid VARCHAR(32) DEFAULT NULL,
  `operator` INT(11) DEFAULT NULL,
  `t_modified` DATETIME DEFAULT NULL,
  PRIMARY KEY (id),
  KEY `tradeid` (tradeid),
  KEY `t_modified` (`t_modified`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO tradelog (id, tradeid, `operator`, `t_modified`)
VALUES (1, 'trade1', 101, '2016-07-15 10:00:00'),
  (2, 'trade2', 102, '2016-07-20 11:00:00'),
  (3, 'trade3', 103, '2017-07-25 12:00:00'),
  (4, 'trade4', 104, '2017-07-30 13:00:00'),
  (5, 'trade5', 105, '2018-07-05 14:00:00'),
  (6, 'trade6', 106, '2018-07-10 15:00:00'),
  (7, 'trade7', 107, '2019-07-15 16:00:00'),
  (8, 'trade8', 108, '2019-07-20 17:00:00'),
  (9, 'trade9', 109, '2020-07-25 18:00:00'),
  (10, 'trade10', 110, '2020-07-30 19:00:00');

EXPLAIN
SELECT COUNT(*)
FROM tradelog
WHERE MONTH(t_modified) = 7;

EXPLAIN
SELECT COUNT(*)
FROM tradelog
WHERE (
    t_modified >= '2016-7-1'
    AND t_modified < '2016-8-1'
  )
  OR (
    t_modified >= '2017-7-1'
    AND t_modified < '2017-8-1'
  )
  OR (
    t_modified >= '2018-7-1'
    AND t_modified < '2018-8-1'
  );
