extends RigidBody2D

@export var startVelocity: Vector2
@export var force: float

func _ready():
	apply_central_force(startVelocity * force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var angle = linear_velocity.angle()
	
	#print(angle)
	
	$Sprite2D.rotation = angle
	
	
	#If contact with player freeze the arrow and reparent to the player body
	# Disable arrow collision here as well
	
	
	
	
