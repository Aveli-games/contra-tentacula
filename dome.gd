extends Area2D

class_name Dome

signal fully_infested
signal targeted

const DOME_SPRITES_PATH = "res://art/dome_sprites"
const INFESTATION_COUNTDOWN = 30

var infestation_percentage: float = 0.0
var infestation_stage: InfestationStage = InfestationStage.UNINFESTED
var infestation_type: Globals.InfestationType = Globals.InfestationType.NONE
var infestation_rate: float = 0.0
var infestation_modifier: float = 0.0
@export var resource_type: Globals.ResourceType = Globals.ResourceType.NONE
var is_hidden: bool = false

enum InfestationStage {UNINFESTED, MINOR, MODERATE, MAJOR, FULL, LOST}

func _ready():
	infestation_rate = Globals.base_infestation_rate
	$ResourceGenerationTimer.start(1) # TODO: Have timer start on game start, not dome spawn

func _process(delta):
	# Process infestation progression inependently in dome's infestation check
	if infestation_percentage > 0:
		add_infestation((infestation_rate + infestation_modifier) * delta)
	
	$Building/InfestationProgress.value = infestation_percentage * 100

func _on_infestation_check_timer_timeout():
	# determine infestation level
	if infestation_percentage <= 0:
		if infestation_stage != InfestationStage.UNINFESTED:
			infestation_stage = InfestationStage.UNINFESTED
			$DomeStatus.text = "Safe"
			$ResourceGenerationTimer.start(1)
		var random_roll = randf()
		if random_roll < .01: # Temp, infestation should be initiated by main eventually
			infestation_percentage += 0.01
			$ResourceGenerationTimer.stop()
	elif infestation_percentage <= .50:
		if infestation_stage != InfestationStage.MINOR:
			infestation_stage = InfestationStage.MINOR
			$DomeStatus.text = "Minor infestation"
			$ResourceGenerationTimer.stop()
	elif infestation_percentage <= .75:
		if infestation_stage != InfestationStage.MODERATE:
			infestation_stage = InfestationStage.MODERATE
			$DomeStatus.text = "Moderate infestation!"
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
	
	if infestation_stage < InfestationStage.FULL:
		$DomeLostCountdownTimer.stop()

func add_infestation(infestation_value: float):
	if infestation_stage != InfestationStage.LOST:
		infestation_percentage = clamp(infestation_percentage + infestation_value, 0, 1)
		
func add_infestation_modifier(change: float):
	infestation_modifier += change
	
func set_sprite(path: String):
	$Building/BuildingSprite.texture = load(path)

func generate_resource():
	if resource_type && resource_type != Globals.ResourceType.NONE:
		Globals.add_resource(resource_type, 1)

func set_resource_type(type: Globals.ResourceType):
	resource_type = type
	match resource_type:
		Globals.ResourceType.FOOD:
			set_sprite("res://art/dome_sprites/Dome_food_96.png")
		Globals.ResourceType.FUEL:
			set_sprite("res://art/dome_sprites/Dome_fuel_96.png")
		Globals.ResourceType.PARTS:
			set_sprite("res://art/dome_sprites/Dome_parts_96.png")
		Globals.ResourceType.RESEARCH:
			set_sprite("res://art/dome_sprites/Dome_science_96.png")

# Only called when becomes fully infested
func _on_fully_infested():
	$DomeLostCountdownTimer.start(INFESTATION_COUNTDOWN)
	##TODO: use signal in DomeConnections instead?
	DomeConnections.dome_start_spread(self as Variant as Area2D)

func _on_dome_lost_countdown_timer_timeout():
	$InfestationCheckTimer.stop()
	infestation_stage = InfestationStage.LOST
	$DomeStatus.text = "Lost"
	$Building/BuildingSprite.modulate = Color.DIM_GRAY

func _on_resource_generation_timer_timeout():
	if resource_type != Globals.ResourceType.RESEARCH:
		generate_resource()

func _on_selection_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			targeted.emit(self)

func enter(squad: Squad):
	squad.location = self
	for slot in $Building/UnitSlots.get_children():
		if not slot.unit:
			slot.fill(squad)
			break

func get_connections():
	var connections = []
	for conneciton in DomeConnections.get_dome_connections(self):
		connections.append(conneciton.b)
		
	return connections
	
func set_highlight(is_enable: bool):
	$Building/BuildingSprite.material.set_shader_parameter("on", is_enable)

func _on_selection_area_mouse_entered():
	set_highlight(true)

func _on_selection_area_mouse_exited():
	set_highlight(false)
