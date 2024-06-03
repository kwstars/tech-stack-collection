package main

import (
	"database/sql"
	"os"
	"sync"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

const DSN = "root:mysql@tcp(127.0.0.1:3306)/test"

func main() {
	var (
		sessionA, sessionB *sql.DB
		err                error
		mu                 sync.Mutex
		cond               = sync.NewCond(&mu)
	)

	zerolog.TimeFieldFormat = zerolog.TimeFormatUnixMs
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339})

	sessionA, err = sql.Open("mysql", DSN)
	handleErr(err, "failed to connect to the database")
	defer sessionA.Close()

	sessionB, err = sql.Open("mysql", DSN)
	handleErr(err, "failed to connect to the database")
	defer sessionB.Close()

	preparingData(sessionA)

	var wg sync.WaitGroup
	wg.Add(2)

	// Goroutine A for locking the inventory table and updating
	go func() {
		defer wg.Done()
		log.Info().Msg("Goroutine A started")
		defer execSQL(sessionA, "UNLOCK TABLES;", "failed to unlock the table")

		execSQL(sessionA, "LOCK TABLES inventory WRITE;", "failed to lock the table")
		log.Info().Msg("Goroutine A locked the table with a write lock")

		execSQL(sessionA, "UPDATE inventory SET quantity = quantity - 5 WHERE product_id = 123;", "failed to update the inventory")
		log.Info().Msg("Goroutine A updated the inventory")

		cond.Broadcast()
		log.Info().Msg("Goroutine A broadcasted the signal")

		log.Info().Msg("Goroutine A sleeping for 5 seconds")
		time.Sleep(10 * time.Second)

		log.Info().Msg("Goroutine A finished")
	}()

	// Goroutine B for updating the inventory table
	go func() {
		defer wg.Done()

		log.Info().Msg("Goroutine B started")
		mu.Lock()
		cond.Wait()
		mu.Unlock()
		log.Info().Msg("Goroutine B woke up")

		var rows *sql.Rows
		if rows, err = sessionB.Query("SELECT * FROM inventory;"); err != nil {
			log.Panic().Err(err).Msg("failed to select from the inventory table")
		}
		defer rows.Close()

		for rows.Next() {
			var productID int
			var quantity int
			if err = rows.Scan(&productID, &quantity); err != nil {
				log.Panic().Err(err).Msg("failed to scan the row")
			}
			log.Info().Int("productID", productID).Int("quantity", quantity).Msg("row")
		}
		handleErr(rows.Err(), "failed to iterate over the rows")
		log.Info().Msg("Goroutine B finished")
	}()

	wg.Wait()
}

// preparingData
func preparingData(db *sql.DB) {
	// Drop the 'inventory' table if it exists
	_, err := db.Exec("DROP TABLE IF EXISTS inventory;")
	if err != nil {
		log.Err(err).Msg("failed to drop the inventory table")
		return
	}

	// Create the 'inventory' table
	_, err = db.Exec(`
        CREATE TABLE inventory (
            product_id INT PRIMARY KEY,
            quantity INT NOT NULL
        );
    `)
	if err != nil {
		log.Err(err).Msg("failed to create the inventory table")
		return
	}
}

func execSQL(db *sql.DB, query string, errorMsg string) {
	if _, err := db.Exec(query); err != nil {
		log.Panic().Err(err).Msg(errorMsg)
	}
}

func handleErr(err error, msg string) {
	if err != nil {
		log.Error().Err(err).Msg(msg)
	}
}
