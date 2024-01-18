@tool
extends Node2D

func _ready():
	if Engine.is_editor_hint():
		for child in self.get_children():
			child.get_node('DomeName').text = child.get_name()
