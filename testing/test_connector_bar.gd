extends Node2D

var repeat_unit = 0

func _ready():
	$TextureProgressBar.value = 0
	repeat_unit = $TextureProgressBar.size.y

func _process(delta):
	$TextureProgressBar.value += delta*10
	$TextureProgressBar/TextureRect.set_size(Vector2($TextureProgressBar/TextureRect.size.x, repeat_unit*$TextureProgressBar.value/100))

