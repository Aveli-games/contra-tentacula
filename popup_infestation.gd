extends Polygon2D

# value 0 - 100
@export var value = 0
var y_height = 80

func _ready():
	$Sprite2D.position.y += y_height

func _process(delta):
	# map value 0 to position 80
	# value 100 to position 0
	$Sprite2D.position.y = y_height - (80 * value/100)
