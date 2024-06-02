package main

import (
	"database/sql"
	"fmt"
	"os"
	"strings"
	"sync"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

const DSN = "root:mysql@tcp(127.0.0.1:3306)/test"

func main() {
	var (
		sessionA, sessionB, sessionC *sql.DB
		wg                           sync.WaitGroup
		t2, t3, t4, t5               = make(chan bool), make(chan bool), make(chan bool), make(chan bool)
	)

	zerolog.TimeFieldFormat = zerolog.TimeFormatUnixMs
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339})

	openDB(&sessionA, "failed to open session A")
	defer sessionA.Close()

	openDB(&sessionB, "failed to open session B")
	defer sessionB.Close()

	openDB(&sessionC, "failed to open session C")
	defer sessionC.Close()

	preparingData(sessionA)

	wg.Add(3)

	// Session A
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine A started")

		log.Info().Msg("Session A: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;")
		execSQL(sessionA, "SET TRANSACTION ISOLATION LEVEL READ COMMITTED;", "Session A failed to set transaction isolation level")

		log.Info().Msg("Session A: BEGIN;")
		execSQL(sessionA, "BEGIN;", "Session A failed to BEGIN;")

		log.Info().Msg("Session A: SELECT * FROM t WHERE d=5 FOR UPDATE;")
		execSQL(sessionA, "SELECT * FROM t WHERE d = 5 FOR UPDATE;", "Session A failed to SELECT")
		t2 <- true

		<-t3
		log.Info().Msg("Session A: SELECT * FROM t WHERE d=5 FOR UPDATE;")
		execSQL(sessionA, "SELECT * FROM t WHERE d = 5 FOR UPDATE;", "Session A failed to SELECT")
		t4 <- true

		<-t5
		log.Info().Msg("Session A: SELECT * FROM t WHERE d=5 FOR UPDATE;")
		execSQL(sessionA, "SELECT * FROM t WHERE d = 5 FOR UPDATE;", "Session A failed to SELECT")

		log.Info().Msg("Session A: COMMIT;")
		execSQL(sessionA, "COMMIT;", "Session A failed to COMMIT;")
	}()

	// Session B
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine B started")

		<-t2
		log.Info().Msg("Session B: UPDATE t SET d = 5 WHERE id = 0;")
		execSQL(sessionB, "UPDATE t SET d = 5 WHERE id = 0;", "Session B failed to UPDATE")
		t3 <- true

		log.Info().Msg("Session B: COMMIT;")
	}()

	// Session C
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine C started")

		<-t4
		log.Info().Msg("Session C: INSERT INTO t VALUES (1, 1, 5);")
		execSQL(sessionC, "INSERT INTO t VALUES (1, 1, 5);", "Session C failed to INSERT")
		t5 <- true
	}()

	wg.Wait()
}

type Row struct {
	ID int
	C  int
	D  int
}

func preparingData(db *sql.DB) {
	var err error
	// Check if the table exists
	row := db.QueryRow("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'test' AND table_name = 't';")
	var count int
	err = row.Scan(&count)
	handleErr(err, "failed to check if the table exists")

	// If the table exists, drop it
	if count > 0 {
		_, err = db.Exec("DROP TABLE t;")
		handleErr(err, "failed to drop the table")
	}

	// Create the table
	_, err = db.Exec(`
		CREATE TABLE t (
		  id int(11) NOT NULL,
		  c int(11) DEFAULT NULL,
		  d int(11) DEFAULT NULL,
		  PRIMARY KEY (id),
		  KEY c (c)
		) ENGINE = Innodb;
	`)
	handleErr(err, "failed to create the table")

	// Define the data to be inserted
	data := []struct {
		id int
		c  int
		d  int
	}{
		{0, 0, 0},
		{5, 5, 5},
		{10, 10, 10},
		{15, 15, 15},
		{20, 20, 20},
		{25, 25, 25},
	}

	// Insert the data
	for _, item := range data {
		_, err = db.Exec("INSERT INTO t (id, c, d) VALUES (?, ?, ?);", item.id, item.c, item.d)
		handleErr(err, "failed to insert data")
	}
}

func execSQL(db *sql.DB, query string, errorMsg string) {
	if strings.HasPrefix(strings.ToUpper(strings.TrimSpace(query)), "SELECT") {
		rows, err := db.Query(query)
		if err != nil {
			log.Panic().Err(err).Msg(errorMsg)
		}
		defer rows.Close()

		for rows.Next() {
			var id, c, d int
			if err := rows.Scan(&id, &c, &d); err != nil {
				log.Panic().Err(err).Msg(errorMsg)
			} else {
				fmt.Printf("id: %d, c: %d, d: %d\n", id, c, d)
			}
		}

		if err := rows.Err(); err != nil {
			log.Panic().Err(err).Msg("Failed to iterate over rows")
		}
	} else {
		if _, err := db.Exec(query); err != nil {
			log.Panic().Err(err).Msg(errorMsg)
		}
	}
}

func handleErr(err error, msg string) {
	if err != nil {
		log.Error().Err(err).Msg(msg)
	}
}

func openDB(db **sql.DB, errorMsg string) {
	var err error
	if *db, err = sql.Open("mysql", DSN); err != nil {
		log.Panic().Err(err).Msg(errorMsg)
	}
}
