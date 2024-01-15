extends Node2D

signal fully_infested

const DOME_SPRITES_PATH = "res://art/dome_sprites"
const INFESTATION_COUNTDOWN = 30

var infestation_percentage: float = 0.0
var infestation_stage: InfestationStage = InfestationStage.UNINFESTED
var infestation_type: Globals.InfestationType = Globals.InfestationType.NONE
var infestation_rate: float = 0.0
var infestation_modifier: float = 0.0
var resource_type: Globals.ResourceType = Globals.ResourceType.NONE
var is_hidden: bool = false
var connections: Dictionary = {}
var dome_sprites = []

enum InfestationStage {UNINFESTED, MINOR, MODERATE, MAJOR, FULL, LOST}

func _ready():
	# Load the dome sprites into an array for easy access
	var dir = DirAccess.open(DOME_SPRITES_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.ends_with(".import"):
				dome_sprites.append(load(DOME_SPRITES_PATH + "/" + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the dome sprites.")

func _on_infestation_check_timer_timeout():
	# Process infestation progression inependently in dome's infestation check
	add_infestation(infestation_rate + infestation_modifier)
	
	# Then determine infestation level
	if infestation_percentage <= 0:
		if infestation_stage != InfestationStage.UNINFESTED:
			infestation_stage = InfestationStage.UNINFESTED
			$DomeStatus.text = "Safe"
			infestation_rate = 0.0
		if randf() < .1 && infestation_rate == 0: # Temp, infestation should be initiated by main eventually
				infestation_rate += .1
	elif infestation_percentage <= .50:
		if infestation_stage != InfestationStage.MINOR:
			infestation_stage = InfestationStage.MINOR
			$DomeStatus.text = "Minor infestation"
	elif infestation_percentage <= .75:
		if infestation_stage != InfestationStage.MODERATE:
			infestation_stage = InfestationStage.MODERATE
			$DomeStatus.text = "Moderate infestiation!"
	elif infestation_percentage < 1:
		if infestation_stage != InfestationStage.MAJOR:
			infestation_stage = InfestationStage.MAJOR
			$DomeStatus.text = "Major infestation!"
	elif infestation_percentage >= 1:
		if infestation_stage != InfestationStage.FULL:
			infestation_stage = InfestationStage.FULL
		if $DomeLostCountdownTimer.is_stopped():
			$DomeStatus.text = "Fully infested: %s" % INFESTATION_COUNTDOWN
			fully_infested.emit()
		else:
			$DomeStatus.text = "Fully infested: %s" % int($DomeLostCountdownTimer.time_left)
	
	# Set sprite based on list of sprites
	$Building/BuildingSprite.texture = dome_sprites[infestation_stage]
	
	if infestation_stage < InfestationStage.FULL:
		$DomeLostCountdownTimer.stop()

func add_infestation(infestation_value: float):
	if infestation_stage != InfestationStage.LOST:
		infestation_percentage = clamp(infestation_percentage + infestation_value, 0, 1)
		
func add_infestation_modifier(change: float):
	infestation_modifier += change

# Only called when becomes fully infested
func _on_fully_infested():
	$DomeLostCountdownTimer.start(INFESTATION_COUNTDOWN)

func _on_dome_lost_countdown_timer_timeout():
	$InfestationCheckTimer.stop()
	infestation_stage = InfestationStage.LOST
	$DomeStatus.text = "Lost"

func _on_area_entered(area):
	if area.name == "Team":
		area.location = name
		add_infestation_modifier(-.15)


func _on_area_exited(area):
	if area.name == "Team":
		add_infestation_modifier(.15)
