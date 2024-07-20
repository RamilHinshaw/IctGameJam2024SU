extends RigidBody2D

@export var startVelocity: Vector2
@export var force: float

func _ready():
	apply_central_force(startVelocity * force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var angle = linear_velocity.angle()

	if $Sprite2D:
		$Sprite2D.rotation = angle
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("HIT")
		$Sprite2D.reparent(body)
		$Area2D.monitoring = false
		
	elif body.is_in_group("Level"):
		print("MISS")
		queue_free()
