extends RigidBody2D

@export var startVelocity: Vector2
@export var force: float

var _hitPlayer: bool = false

#AUDIO
@export var sfx_fire:AudioStream
@export var sfx_hitMiss:AudioStream

@export var textures:Array[Texture]

@onready var sprite:Sprite2D = $Sprite2D

func _ready():
	#Random Texture
	sprite.texture = textures.pick_random()
	
	
	apply_central_force(startVelocity * force * 10000)
	Global.play_sfx(sfx_fire)	
	
	await get_tree().create_timer(5).timeout
	queue_free()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var angle = linear_velocity.angle()
	self.rotation = angle

	#if $Sprite2D:
		#$Sprite2D.rotation = angle
	

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("Player") && !_hitPlayer:
		#if body.is_in_group("Head"):
			#print("DEATH!")
			#get_tree().reload_current_scene()
		
		#print("HIT: " + body.name)
		#EventBus.emit_signal("player_hit", body.name)
		EventBus.player_hit.emit(body.name)
		$Sprite2D.reparent(body, true)
		
		$Area2D.monitoring = false
		linear_velocity = Vector2.ZERO
		_hitPlayer = true
		queue_free()
		
	elif body.is_in_group("Level"):
		print("MISS")
		Global.play_sfx(sfx_hitMiss)
		
		if (!Global.gameOver):
			Global.dodgeArrows += 1
		
		
		if ($Sprite2D):
			$Sprite2D.reparent(body)
		queue_free()
