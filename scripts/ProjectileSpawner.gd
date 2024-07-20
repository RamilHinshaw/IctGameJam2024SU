extends Node

@export var projectile: PackedScene = preload("res://prefabs/arrow.tscn")
@export var timer = 0.3
@export var reverse: bool

@export var spawnPosY:Vector2 = Vector2(20, 1000)

#@export var rdmForceX:Vector2 = Vector2(20, 1000)
#@export var rdmForceY:Vector2 = Vector2(20, 1000)

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3.0).timeout
	fireProjectile()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	pass


func fireProjectile():
	var instance = projectile.instantiate()
	var rng = RandomNumberGenerator.new()
	instance.global_position.y = rng.randf_range(spawnPosY.x, spawnPosY.y)	
	instance.force = rng.randf_range(0.4, 1.5)
	
	if (reverse):
		instance.startVelocity.x *= -1
	
	add_child(instance)
	await get_tree().create_timer(timer).timeout
	fireProjectile()
