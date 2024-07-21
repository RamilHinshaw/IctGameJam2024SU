extends TextureButton

@export var scene: PackedScene
@export var grabThisfocus: bool = false
@export var exit_instead: bool = false

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	if exit_instead:
		get_tree().quit()
	
	else:
		change_scene()

#Kinda hardcoded eeesh
#func _ready():
	#if grabThisfocus:
		#grab_focus()
		#
#func set_focus():
	#grab_focus()

func change_scene():
	#get_tree().change_scene_to(scene)
	get_tree().change_scene_to_packed(scene)
