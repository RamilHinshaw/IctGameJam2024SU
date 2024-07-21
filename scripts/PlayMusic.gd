extends Node

@export var music:AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.play_music(music)
