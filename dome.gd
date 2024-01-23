extends Area2D

class_name Dome

signal fully_infested
signal infestation_removed
signal targeted

const DOME_SPRITES_PATH = "res://art/dome_sprites"
const INFESTATION_COUNTDOWN = 30

var infestation_percentage: float = 0.0
var infestation_stage: Globals.InfestationStage = Globals.InfestationStage.UNINFESTED
var infestation_type: Globals.InfestationType = Globals.InfestationType.NONE
var infestation_chance = Globals.BASE_INFESTATION_CHANCE
var infestation_chance_modifiers = {}
@export var resource_type: Globals.ResourceType = Globals.ResourceType.NONE
var is_hidden: bool = false

func _ready():
	$ResourceGenerationTimer.start(1) # TODO: Have timer start on game start, not dome spawn
	%PopupInfestation.value = 0

func _process(delta):
	# Process infestation progression inependently in dome's infestation check
	if infestation_percentage > 0:
		add_infestation(Globals.BASE_DOME_INFESTATION_RATE * delta)
	
	var progress_diff = infestation_percentage - %PopupInfestation.value/100
	var progress_max_speed = 0.01
	var progress_adjustment = clamp(-progress_max_speed, progress_diff, progress_max_speed)
	if progress_adjustment != 0:
		%PopupInfestation.value += progress_adjustment * 100
		

func _on_infestation_check_timer_timeout():
	# determine infestation level
	if infestation_percentage <= 0:
		if infestation_stage != Globals.InfestationStage.UNINFESTED:
			infestation_stage = Globals.InfestationStage.UNINFESTED
			$DomeStatus.text = "Safe"
			$ResourceGenerationTimer.start(1)
		var random_roll = randf()
		if random_roll < get_modified_infestation_chance():
			infestation_percentage += 0.01
	elif infestation_percentage <= .50:
		if infestation_stage != Globals.InfestationStage.MINOR:
			infestation_stage = Globals.InfestationStage.MINOR
			$DomeStatus.text = "Minor infestation"
	elif infestation_percentage <= .75:
		if infestation_stage != Globals.InfestationStage.MODERATE:
			infestation_stage = Globals.InfestationStage.MODERATE
			$DomeStatus.text = "Moderate infestation!"
			$ResourceGenerationTimer.stop()
	elif infestation_percentage < 1:
		if infestation_stage != Globals.InfestationStage.MAJOR:
			infestation_stage = Globals.InfestationStage.MAJOR
			$DomeStatus.text = "Major infestation!"
	elif infestation_percentage >= 1:
		if infestation_stage != Globals.InfestationStage.FULL:
			infestation_stage = Globals.InfestationStage.FULL
		if $DomeLostCountdownTimer.is_stopped():
			$DomeStatus.text = "Fully infested: %s" % INFESTATION_COUNTDOWN
			fully_infested.emit()
		else:
			$DomeStatus.text = "Fully infested: %s" % int($DomeLostCountdownTimer.time_left)
	
	if infestation_stage < Globals.InfestationStage.FULL:
		$DomeLostCountdownTimer.stop()

func add_infestation(infestation_value: float):
	if infestation_stage != Globals.InfestationStage.LOST:
		var old_infestation_percentage = infestation_percentage
		infestation_percentage = clamp(infestation_percentage + infestation_value, 0, 1)
		
		# when the dome is cleansed
		if old_infestation_percentage > 0 && infestation_value < 0 && infestation_percentage == 0:
			infestation_removed.emit()
			##TODO: use signal in DomeConnections instead?
			DomeConnections.dome_stop_spread(self)

func add_infestation_chance_modifier(modifier_id, chance):
	if !infestation_chance_modifiers.has(modifier_id):
		infestation_chance_modifiers[modifier_id] = chance
	
func remove_infestation_chance_modifier(modifier_id):
	if infestation_chance_modifiers.has(modifier_id):
		infestation_chance_modifiers.erase(modifier_id)
	else:
		push_warning('Tried to remove missing chance modifier: ', modifier_id)

func get_modified_infestation_chance():
	if infestation_chance_modifiers.is_empty():
		return infestation_chance
	var total_modifiers = infestation_chance_modifiers.values().reduce(sum) 
	return infestation_chance + total_modifiers

func sum(accum, number):
	return accum + number

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
	DomeConnections.dome_start_spread(self)

func _on_dome_lost_countdown_timer_timeout():
	$InfestationCheckTimer.stop()
	infestation_stage = Globals.InfestationStage.LOST
	$DomeStatus.text = "Lost"
	$Building/BuildingSprite.modulate = Color.DIM_GRAY
	$Building/FlowerSprite.show()

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
		connections.append(conneciton.dome_b)
		
	return connections

func set_highlight(is_enable: bool):
	$Building/BuildingSprite.material.set_shader_parameter("on", is_enable)

func _on_selection_area_mouse_entered():
	set_highlight(true)

func _on_selection_area_mouse_exited():
	set_highlight(false)

func is_occupied():
	var unit_slots = $Building/UnitSlots.get_children()
	return unit_slots.any(func(slot): return slot.unit)
