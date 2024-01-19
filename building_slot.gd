extends Node2D

class_name BuildingSlot

var unit: Squad

func fill(body: Squad):
	body.target_position = global_position
	unit = body
	body.slot = self

func empty(body: Squad):
	unit = null
	body.slot = null
