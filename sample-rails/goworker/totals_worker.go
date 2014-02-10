package main

import (
  "database/sql"
  "errors"
  "reflect"
  "log"
  "fmt"
  _ "github.com/lib/pq"
  "github.com/benmanns/goworker"
)

func init() {
  goworker.Register("TotalsJob", totalsWorker())
}

func totalsWorker() func(string, ...interface{}) error {
  db, err := sql.Open("postgres", "dbname=sample_development sslmode=disable")

  if err != nil {
    fmt.Println(err, log.Lshortfile)
  }

  return func(queue string, args ...interface{}) (err error) {
    if len(args) < 1 {
      err = errors.New("job must have at least 1 argument (extra args are ignored)")
    }
    for _, arg := range(args[:1]) {
      if reflect.TypeOf(arg).String() != "float64" {
        err = errors.New("required arguments must be numeric")
      }
    }

    if err == nil {
      userId := int(args[0].(float64))

      total := getTotal(db, userId)

      var id int
      // Scan is very required, otherwise the row is not closed
      db.QueryRow("INSERT INTO totals (user_id, total) VALUES($1, $2) RETURNING id", userId, total).Scan(&id)
    }

    return
  }
}

func getTotal(db *sql.DB, id int) (total interface{}) {
  err := db.QueryRow("SELECT SUM(count) FROM items WHERE user_id = $1", id).
          Scan(&total)

  if err != nil {
    fmt.Println(err, log.Lshortfile)
  }

  return
}
