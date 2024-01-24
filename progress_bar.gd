extends ProgressBar

func _ready():
	Globals.resource_updated.connect(_on_resource_updated)
	max_value = Globals.RESEARCH_WIN_THRESHOLD

func _on_resource_updated(resource_type: Globals.ResourceType):
		if resource_type == Globals.ResourceType.RESEARCH:
			value = Globals.resources[resource_type]
