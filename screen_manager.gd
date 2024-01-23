extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("new_animation")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
