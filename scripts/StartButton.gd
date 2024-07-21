extends Node

var _tutorialOpen: bool = false
@export var scene: PackedScene

func _on_pressed():
	$"../../Info".visible = true
	$"..".visible = false
	_tutorialOpen = true

func _process(delta):
	if _tutorialOpen:
		if Input.is_action_just_pressed("Left") || Input.is_action_just_pressed("Right"):
			get_tree().change_scene_to_packed(scene)
