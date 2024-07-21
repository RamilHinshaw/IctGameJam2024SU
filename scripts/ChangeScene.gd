extends Node

@export var scene: PackedScene

func change_scene():
	get_tree().change_scene_to(scene)

