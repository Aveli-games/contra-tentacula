extends Node2D

class_name BuildingSlot

var unit: Squad

func fill(body: Squad):
	body.target_position = global_position
	unit = body
	body.slot = self
	if body.location.present_squads.find(body) == -1:
		$Squad.text = str(body.get_instance_id())
		body.location.present_squads.append(body)

func empty(body: Squad):
	unit = null
	body.slot = null
	body.location.present_squads.erase(body)
	$Squad.text = ""
