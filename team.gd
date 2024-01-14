extends Node2D

@onready var main = get_tree().root.get_node("Main")

signal use_brute_force

@export var location: String

