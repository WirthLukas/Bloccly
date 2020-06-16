package data

import (
	"fmt"
	r "gopkg.in/rethinkdb/rethinkdb-go.v6"
	"log"
	"strconv"
)

type Repository struct {
	Session *r.Session
}

func ConnectToDb() *Repository {
	session, err := r.Connect(r.ConnectOpts{
		Address: "localhost:28015",
	})

	if err != nil {
		log.Fatalln(err)
	}

	repo := Repository{Session: session}
	return &repo
}

func WriteToDb(repository *Repository, playerid int, points int) {
	err := r.DB("bloccly").Table("scores").Insert(map[string]string{
		"playerid": strconv.Itoa(playerid),
		"points": strconv.Itoa(points),
	}).Exec(repository.Session)

	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Written Data to DB!")
}

func ReadScores(repository *Repository) {
	res, err := r.DB("bloccly").Table("scores").Run(repository.Session)/*.Filter(map[string]interface{}{
		"tag": "name",
	}).Run(repository.Session)*/

	if err != nil {
		fmt.Println(err)
		return
	}
	defer res.Close()

	if res.IsNil() {
		fmt.Println("No rows found!")
		return
	}

	var names []interface{}
	err = res.All(&names)

	if err != nil {
		fmt.Println("Error at scanning database result!")
		return
	}

	for _, element := range names{
		fmt.Println(element)
	}
}

func ReadFromDb(repository *Repository) {
	res, err := r.DB("bloccly").Table("scores").Run(repository.Session)/*.Filter(map[string]interface{}{
		"tag": "name",
	}).Run(repository.Session)*/

	if err != nil {
		fmt.Println(err)
		return
	}
	defer res.Close()

	if res.IsNil() {
		fmt.Println("No rows found!")
		return
	}

	//fmt.Println(res)

	var names []interface{}
	err = res.All(&names)
	fmt.Println(names)

	if err != nil {
		fmt.Println("Error at scanning database result!")
		return
	}

	for _, element := range names{
		fmt.Println(element)
	}
}