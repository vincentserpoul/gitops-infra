package main

import (
	"bufio"
	"database/sql"
	"fmt"
	"log"
	"os"
	"strings"

	_ "github.com/lib/pq"
)

func main() {
	fmt.Printf("enter db password: ")
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil {
		log.Fatalln("failed to read input")
	}

	input = strings.TrimSpace(input)
	connStr := fmt.Sprintf("postgresql://postgres:%s@localhost:5432/postgres?sslmode=disable", input)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("error connecting to the database: ", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("error ping %v", err)
	}

	log.Println("connected")
}
