package blocks

type BlockTypes int

const (
	Cyan BlockTypes = iota
	Blue
	Orange
	Yellow
	Green
	Purple
	Red
)

func (block BlockTypes) Block() string {
	return [...]string{"Cyan", "Blue", "Orange", "Yellow", "Green", "Purple", "Red"}[block]
}
