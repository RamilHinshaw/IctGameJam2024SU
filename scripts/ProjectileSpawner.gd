extends Node

@export var projectile: PackedScene = preload("res://prefabs/arrow.tscn")
@export var timer = 0.3
@export var reverse: bool
@export var isVertical: bool

@export var spawnPosY:Vector2 = Vector2(20, 1000)

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3.0).timeout
	fireProjectile()
	
	if isVertical:
		await get_tree().create_timer(4.0).timeout
		aimHead()
		
func aimHead():
	var instance = projectile.instantiate()
	instance.global_position.x = Global.playerHead.global_position.x
	add_child(instance)
	await get_tree().create_timer(6.0).timeout
	aimHead()	
	
	
func fireProjectile():
	var instance = projectile.instantiate()
	var rng = RandomNumberGenerator.new()
	
	if (!isVertical):
		instance.global_position.y = rng.randf_range(spawnPosY.x, spawnPosY.y)
	else:
		#instance.global_position.y = get_node('.').global_position
		instance.global_position.x = rng.randf_range(spawnPosY.x, spawnPosY.y)
		
	instance.force = rng.randf_range(0.4, 1.5)
	
	if (isVertical):
		instance.startVelocity.x = 0
		instance.startVelocity.y = 0
	
	if (reverse):
		instance.startVelocity.x *= -1
	
	add_child(instance)
	await get_tree().create_timer(timer).timeout
	fireProjectile()
