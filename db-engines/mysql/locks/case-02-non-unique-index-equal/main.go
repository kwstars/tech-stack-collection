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
		t2, t3                       = make(chan bool), make(chan bool)
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

		execSQL(sessionA, "A", "BEGIN;")
		execSQL(sessionA, "A", "SELECT id FROM t WHERE c = 5 LOCK IN SHARE MODE;") // C 会 blocked
		// execSQL(sessionA, "A", "SELECT c FROM t WHERE c = 5 LOCK IN SHARE MODE;")  // C 会 blocked
		// execSQL(sessionA, "A", "SELECT d FROM t WHERE c = 5 LOCK IN SHARE MODE;") // B 和 C 都会 blocked
		// execSQL(sessionA, "A", "SELECT id FROM t WHERE c = 5 FOR UPDATE;") // B 和 C 都会 blocked
		t2 <- true

		log.Info().Msg("Goroutine A is finished")
	}()

	// Session B
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine B started")

		<-t2
		t3 <- true
		execSQL(sessionB, "B", "UPDATE t SET d = d + 1 WHERE id = 5;")

		log.Info().Msg("Goroutine B is finished")
	}()

	// Session C
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine C started")

		<-t3
		// execSQL(sessionC, "C blocked", "INSERT INTO t VALUES(2, 2, 2);")
		execSQL(sessionC, "C blocked", "INSERT INTO t VALUES(7, 7, 7);")

		log.Info().Msg("Goroutine C is finished")
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

	// Build the values string
	values := make([]string, 0, len(data))
	for _, item := range data {
		values = append(values, fmt.Sprintf("(%d, %d, %d)", item.id, item.c, item.d))
	}

	// Create the SQL statement
	sql := "INSERT INTO t (id, c, d) VALUES " + strings.Join(values, ",") + ";"

	// Execute the SQL statement
	_, err = db.Exec(sql)
	handleErr(err, "failed to insert data")
}

func execSQL(db *sql.DB, session string, query string) {
	log.Info().Msg(fmt.Sprintf("Session %s: %s", session, query))
	if strings.HasPrefix(strings.ToUpper(strings.TrimSpace(query)), "SELECT") {
		rows, err := db.Query(query)
		if err != nil {
			log.Panic().Err(err).Msg(session + ": failed" + " " + query)
		}
		defer rows.Close()

		columns, _ := rows.Columns()
		for rows.Next() {
			switch len(columns) {
			case 1:
				var id int
				if err := rows.Scan(&id); err != nil {
					log.Panic().Err(err).Msg(session + ": failed" + " " + query)
				} else {
					fmt.Printf("id: %d\n", id)
				}
			case 3:
				var id, c, d int
				if err := rows.Scan(&id, &c, &d); err != nil {
					log.Panic().Err(err).Msg(session + ": failed" + " " + query)
				} else {
					fmt.Printf("id: %d, c: %d, d: %d\n", id, c, d)
				}
			default:
				log.Panic().Msg("Unexpected number of columns")
			}
		}

		if err := rows.Err(); err != nil {
			log.Panic().Err(err).Msg("Failed to iterate over rows")
		}
	} else {
		if _, err := db.Exec(query); err != nil {
			log.Panic().Err(err).Msg(session + ": failed" + " " + query)
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
