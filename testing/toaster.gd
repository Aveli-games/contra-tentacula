extends Node2D

@export var value = 0
var y_height = 80

func _ready():
	$Sprite2D.position.y += y_height

func _process(delta):
	$Sprite2D.position.y = max( 0, $Sprite2D.position.y - 1)
