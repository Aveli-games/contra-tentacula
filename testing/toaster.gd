extends Node2D

func _ready():
	$Polygon2D/Sprite2D.position.y += 100

func _process(delta):
	$Polygon2D/Sprite2D.position.y = max( 0, $Polygon2D/Sprite2D.position.y - 1)
