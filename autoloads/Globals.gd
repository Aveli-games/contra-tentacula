extends Node

signal resource_updated
signal research_win

enum InfestationType {NONE, AIR, WATER, GROUND}
enum InfestationStage {NONE, UNINFESTED, MINOR, MODERATE, MAJOR, FULL, LOST}
enum ResourceType {NONE, FOOD, FUEL, PARTS, RESEARCH}
enum SquadType {NONE, SCIENTIST, PYRO, BOTANIST, ENGINEER}
enum ActionType {NONE, MOVE, SPECIAL, FIGHT}

var BASE_DOME_INFESTATION_RATE = .1
var BASE_CONNECTOR_INFESTATION_RATE = 0.1
var BASE_INFESTATION_CHANCE = 0.012
var RESEARCH_WIN_THRESHOLD = 500
const DOME_REMAINING_LOSS_THRESHOLD = 5
const INFESTATION_COUNTDOWN = 30
const DOME_TYPE_LIMITS = {
	Globals.ResourceType.NONE: 0,
	Globals.ResourceType.FOOD: 6,
	Globals.ResourceType.FUEL: 3,
	Globals.ResourceType.PARTS: 3,
	Globals.ResourceType.RESEARCH: 3
}

# squad
var BASE_MOVE_SPEED = 100 
var BASE_INFESTATION_FIGHT_RATE = -BASE_DOME_INFESTATION_RATE

var resources = {
	ResourceType.FOOD: 0,
	ResourceType.FUEL: 0,
	ResourceType.PARTS: 0,
	ResourceType.RESEARCH: 0
}

func add_resource(type: ResourceType, change: int):
	resources[type] += change
	resource_updated.emit(type)
	if type == ResourceType.RESEARCH && resources[type] >= RESEARCH_WIN_THRESHOLD:
		research_win.emit()
