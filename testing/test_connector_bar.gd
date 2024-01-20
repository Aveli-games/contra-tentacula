extends Node2D

var repeat_length = 0
var width = 0

func _ready():
	$TextureProgressBar.value = 0
	repeat_length = $TextureProgressBar.size.y
	width = $TextureProgressBar/TextureRect.size.x

func _process(delta):
	$TextureProgressBar.value += delta*10
	$TextureProgressBar/TextureRect.set_size(Vector2($TextureProgressBar/TextureRect.size.x, repeat_length*$TextureProgressBar.value/100))

