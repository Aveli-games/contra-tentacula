extends Node

enum InfestationType {NONE, AIR, WATER, GROUND}
enum ResourceType {NONE, FOOD, FUEL, PARTS, RESEARCH}

var base_infestation_rate = .1
const BASE_CONNECTOR_INFESTATION_RATE = 0.1

var resources = {
	"food": 0,
	"fuel": 0,
	"parts": 0,
	"research": 0
}

