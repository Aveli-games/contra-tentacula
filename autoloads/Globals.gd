extends Node

signal resource_updated

enum InfestationType {NONE, AIR, WATER, GROUND}
enum InfestationStage {UNINFESTED, MINOR, MODERATE, MAJOR, FULL, LOST}
enum ResourceType {NONE, FOOD, FUEL, PARTS, RESEARCH}
enum SquadType {NONE, SCIENTIST, PYRO, BOTANIST, ENGINEER}
enum ActionType {NONE, MOVE, SPECIAL, FIGHT}

var BASE_DOME_INFESTATION_RATE = .1
var BASE_CONNECTOR_INFESTATION_RATE = 0.1
var BASE_INFESTATION_CHANCE = 0.012

var resources = {
	ResourceType.FOOD: 0,
	ResourceType.FUEL: 0,
	ResourceType.PARTS: 0,
	ResourceType.RESEARCH: 0
}

func add_resource(type: ResourceType, change: int):
	resources[type] += change
	resource_updated.emit(type)
