extends Node2D

signal fully_infested

var infestation_percentage: float = 0.0
var infestation_type: InfestationType = InfestationType.NONE
var resource_type: ResourceType = ResourceType.NONE
var is_hidden: bool = false
var is_lost: bool = false
var connections: Dictionary = {}

enum InfestationType {NONE, AIR, WATER, GROUND}
enum ResourceType {NONE, FOOD, FUEL, PARTS, RESEARCH}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_infestation_check_timer_timeout():
	if infestation_percentage <= 0:
		$Building/BuildingSprite.texture = load("res://art/Dome_uninfested.png")
		$DomeStatus.text = "Safe"
	elif infestation_percentage <= .50:
		$Building/BuildingSprite.texture = load("res://art/Dome_25_infested.png")
		$DomeStatus.text = "Minor infested"
	elif infestation_percentage <= .75:
		$Building/BuildingSprite.texture = load("res://art/Dome_50_infested.png")
		$DomeStatus.text = "Moderate infestiation!"
	elif infestation_percentage < 1:
		$Building/BuildingSprite.texture = load("res://art/Dome_75_infested.png")
		$DomeStatus.text = "Major infestation!"
	elif infestation_percentage >= 1:
		$Building/BuildingSprite.texture = load("res://art/Dome_infested.png")
		$DomeStatus.text = "Fully infested: %s" % $DomeLostCountdownTimer.time_left
		fully_infested.emit()
		
func add_infestation(infestation_value: float):
	infestation_percentage += infestation_value

func _on_fully_infested():
	$DomeLostCountdownTimer.start()

func _on_dome_lost_countdown_timer_timeout():
	$InfestationCheckTimer.stop()
	is_lost = true
	$DomeStatus.text = "Lost"
