extends Node

const BASE_INFESTATION_RATE = 0.05
const BASE_INFESTATION_CHANCE_PER_TICK = 0.05

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for child in $Domes.get_children():
		if randf() < BASE_INFESTATION_CHANCE_PER_TICK:
			child.add_infestation(BASE_INFESTATION_RATE)
