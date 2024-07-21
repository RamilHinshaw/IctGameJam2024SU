extends Node

#@export var characters: Array[PackedScene]

@export var characterInScene: Array[Node2D]


# Called when the node enters the scene tree for the first time.
func _ready():
	var chosenChar = characterInScene.pick_random()
	
	chosenChar.setHead()
	
	for character in characterInScene:
		if character != chosenChar:
			character.queue_free()
	#spawnRdmCharacter()

#func spawnRdmCharacter():
	#var instance = characters.pick_random().instantiate()
	##instance.global_position = self.global_position
	#instance.global_position.x = 992.186
	#instance.global_position.x = 868.162
	#add_child(instance)
