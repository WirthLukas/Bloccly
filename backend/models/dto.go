package models

import (
	"encoding/json"
	"log"
)

type CommandType int

const (
	Id CommandType = iota
	Loss
	BlockUpdate
	NewBlock
	NewPlayer
)

func Command(command int) CommandType {
	return [...]CommandType{Id, Loss, BlockUpdate, NewBlock, NewPlayer}[command]
}

func (command CommandType) CommandToString() string {
	return [...]string{"Id", "Loss", "BlockUpdate", "NewBlock", "NewPlayer"}[command]
}

type CommandDto struct {
	Command int `json:"command"`
	PlayerId int `json:"playerId"`
	Data string `json:"data"`
}

func ParseJSON(data []byte) *CommandDto {
	var dto *CommandDto
	err := json.Unmarshal(data, &dto)
	if err != nil {
		log.Fatalln("[ERROR]: ParseJSON has thrown an exception: ", err)
	}
	return dto
}