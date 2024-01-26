extends Node

signal resource_updated
signal research_win

enum InfestationType {NONE, AIR, WATER, GROUND}
enum InfestationStage {NONE, UNINFESTED, MINOR, MODERATE, MAJOR, FULL, LOST}
enum ResourceType {NONE, FOOD, FUEL, PARTS, RESEARCH}
enum SquadType {NONE, SCIENTIST, PYRO, BOTANIST, ENGINEER}
enum ActionType {NONE, MOVE, SPECIAL, FIGHT}

var BASE_DOME_INFESTATION_RATE = .05
var BASE_CONNECTOR_INFESTATION_RATE = 0.075
var BASE_INFESTATION_CHANCE = 0.008
const ROOTED_INFESTATION_CHANCE_MODIFIER = 0.13
var RESEARCH_WIN_THRESHOLD = 300
const RESEARCH_DOME_LOSS_MAX_THRESHOLD = 4
const MIN_REMAINING_DOME_THRESHOLD = 5
const INFESTATION_COUNTDOWN = 60
var DOME_TYPE_LIMITS = { # 15 domes total or crash
	Globals.ResourceType.NONE: 5,
	Globals.ResourceType.FOOD: 4,
	Globals.ResourceType.FUEL: 1,
	Globals.ResourceType.PARTS: 1,
	Globals.ResourceType.RESEARCH: RESEARCH_DOME_LOSS_MAX_THRESHOLD,
}

# resource management
const _RESOURCES_PER_SECOND = 0.5
const RESOUCE_TIMER_DURATION = 1/_RESOURCES_PER_SECOND

# squad
var BASE_MOVE_SPEED = 50 
var BASE_INFESTATION_FIGHT_RATE = -BASE_DOME_INFESTATION_RATE
var PYRO_SPECIAL_FUEL_USAGE = -2
var ENGI_SPECIAL_PARTS_USAGE = -2

var resources = {
	ResourceType.FOOD: 0,
	ResourceType.FUEL: 0,
	ResourceType.PARTS: 0,
	ResourceType.RESEARCH: 0
}

var infested_domes = 0
var remaining_domes = 15
var remaining_research_domes = RESEARCH_DOME_LOSS_MAX_THRESHOLD

func add_resource(type: ResourceType, change: float):
	resources[type] += change
	resource_updated.emit(type)
	if type == ResourceType.RESEARCH && resources[type] >= RESEARCH_WIN_THRESHOLD:
		research_win.emit()

func reset():
	infested_domes = 0
	remaining_domes = 15
	remaining_research_domes = RESEARCH_DOME_LOSS_MAX_THRESHOLD
	DOME_TYPE_LIMITS = { # 15 domes total or crash
		Globals.ResourceType.NONE: 5,
		Globals.ResourceType.FOOD: 4,
		Globals.ResourceType.FUEL: 1,
		Globals.ResourceType.PARTS: 1,
		Globals.ResourceType.RESEARCH: RESEARCH_DOME_LOSS_MAX_THRESHOLD,
	}
	resources = {
		ResourceType.FOOD: 0,
		ResourceType.FUEL: 0,
		ResourceType.PARTS: 0,
		ResourceType.RESEARCH: 0
	}
