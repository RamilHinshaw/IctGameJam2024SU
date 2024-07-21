extends Node2D


@export var power = 200
@export var upwardPower = 100
@export var bonusForce = 150000
@export var jumpForce = 200000

@export var lastInputTimerMin = 0.2
@export var lastJumpInputTimerMin = 0.04

#AUDIO
@export var sfx_playerHit:Array[AudioStream]
@export var sfx_playerDeath: Array[AudioStream]
@export var sfx_lose: Array[AudioStream]

var _lastInputTime: float = 0
var _lastInputAxis: float = 0

var _isLeftHeld: bool
var _isRightHeld: bool

var _isAirborne: bool = false

var _isDead: bool = false

var bodyParts = []

#BRUTE FORCE!
var headJointHealth: int = 1
var leftArmJointHealth: int = 3
var rightArmJointHealth: int = 3
var leftLegointHealth: int = 3
var rightLegJointHealth: int = 3

func _ready():
	var bodyParts = [$Body,$Head,$"ArmInner-Left",$"ArmOuter-Left",$"ArmInner-Right",$"ArmOuter-Right",$"LegInner-Left",$"LegOuter-Left",$"LegInner-Right",$"LegOuter-Right"]
	EventBus.player_hit.connect(hurtBody.bind()) 
	
	
	
	#await get_tree().create_timer(3).timeout
	#$Joints/LeftArm.queue_free()
	
func setHead():
	Global.playerHead = $Head
			
func hurtBody(bodyPart):
	print("HIT: " + bodyPart)
	
	if (_isDead):
		return
	
	if (bodyPart == "Head"):
		headJointHealth -= 1
		if headJointHealth <= 0 && $Joints/HeadBody:
			$Joints/HeadBody.queue_free()
			onDeath()
			return
	
	elif (bodyPart == "ArmInner-Left" || "ArmOuter-Left" ):
		leftArmJointHealth -= 1
		if leftArmJointHealth <= 0 && $Joints/LeftArmBody:
			$Joints/LeftArmBody.queue_free()
		
	elif (bodyPart == "ArmInner-Right" || "ArmOuter-Right" ):
		rightArmJointHealth -= 1
		if rightArmJointHealth <= 0 && $Joints/RightArmBody:
			$Joints/RightArmBody.queue_free()

	elif (bodyPart == "LegInner-Left" || "LegOuter-Left" ):
		leftLegointHealth -= 1
		if leftLegointHealth <= 0 && $Joints/LeftLegBody:
			$Joints/LeftLegBody.queue_free()
		
	elif (bodyPart == "LegInner-Right" || "LegOuter-Right" ):
		rightLegJointHealth -= 1
		if rightLegJointHealth <= 0 && $Joints/RightLegBody:
			$Joints/RightLegBody.queue_free()
			
	Global.play_sfx(sfx_playerHit.pick_random())


#func _process(delta):
	#if Input.is_key_pressed(KEY_R):
		#get_tree().reload_current_scene()
		#Engine.time_scale = 1.0

func onDeath():	
	print("DEATH!")
	_isDead = true
	Global.play_sfx(sfx_playerDeath.pick_random())
	Global.play_sfx(sfx_lose.pick_random())
	#Global.gameOver = true
	Global.game_over()	


func _physics_process(delta):
	
	if (_isDead):
		return
	
	var axis = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	var force: Vector2 = Vector2.UP * upwardPower + Vector2.RIGHT * axis * power
	
	_isAirborne = !$Body.position.y >= 240
	#print("AIRBORNE: " + str(_isAirborne))
	
	#print($Body.position.y)
		
		
	if Input.is_action_just_pressed("Left") || Input.is_action_just_pressed("Right"):
		
		var lastInputDelay = (Time.get_ticks_msec() - _lastInputTime)/1000
		print(lastInputDelay)
			
		if lastInputDelay <= lastInputTimerMin:
			print("Fast Input detected!")
			
			if (_lastInputAxis == axis):
				
				#var calcUpwardForce = Vector2.UP * bonusForce/8
				#
				#if (!_isAirborne):
					#calcUpwardForce = Vector2.UP * bonusForce/3
					
				var calcUpwardForce = Vector2.UP * bonusForce/3
				
				#resetVelocity()
				$Body.apply_central_force(Vector2.RIGHT * axis * bonusForce + calcUpwardForce)
				print("DASH")
			
		if ((_lastInputAxis != axis && lastInputDelay <= lastJumpInputTimerMin) ||
		 (axis == 0 && !_isLeftHeld && !_isRightHeld)):
			
			#if (!_isAirborne):
				$Body.apply_central_force(Vector2.UP * jumpForce)
				#$"ArmOuter-Right".apply_central_force(Vector2.UP * jumpForce*2)
				#$"ArmOuter-Left".apply_central_force(Vector2.UP * jumpForce*2)
				#print("JUMP")
		
		
		# Reset
		_lastInputTime = Time.get_ticks_msec()
		_lastInputAxis = axis
		
		
	#If on ground
	if Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
		$Body.apply_central_impulse(Vector2.RIGHT * axis * power)
		$Head.apply_central_impulse(Vector2.UP * power)
	
	if Input.is_action_pressed("Left"):
		#$"ArmOuter-Left".apply_impulse(Vector2.UP * upwardPower + Vector2.RIGHT * axis * upwardPower/6, Vector2.ZERO)
		$"ArmOuter-Left".apply_impulse(Vector2.RIGHT * axis * upwardPower/6, Vector2.ZERO)
		_isLeftHeld = true
		
		
	if Input.is_action_pressed("Right"):
		#$"ArmOuter-Right".apply_impulse(Vector2.UP * upwardPower + Vector2.RIGHT * axis * upwardPower/6 ,Vector2.ZERO)
		$"ArmOuter-Right".apply_impulse(Vector2.RIGHT * axis * upwardPower/6 ,Vector2.ZERO)
		_isRightHeld = true
		
	if Input.is_action_just_released("Left"):
		_isLeftHeld = false
		
	if Input.is_action_just_released("Right"):
		_isRightHeld = false
		
	#clampVelocity()
	#print($Head.linear_velocity)

func resetVelocity():
	pass
	#$Body.linear_velocity = Vector2.ZERO
	#$Head.linear_velocity = Vector2.ZERO
	#$"ArmInner-Left".linear_velocity = Vector2.ZERO
	#$"ArmOuter-Left".linear_velocity = Vector2.ZERO
	#$"ArmInner-Right".linear_velocity = Vector2.ZERO
	#$"ArmOuter-Right".linear_velocity = Vector2.ZERO
	#$"LegInner-Left".linear_velocity = Vector2.ZERO
	#$"LegOuter-Left".linear_velocity = Vector2.ZERO
	#$"LegInner-Right".linear_velocity = Vector2.ZERO
	#$"LegOuter-Right".linear_velocity = Vector2.ZERO

func clampVelocity():

	var max = 1700
	var min = -700
	
	#pass
	$Body.linear_velocity.x = clampf($Body.linear_velocity.x, -max, max)
	$Body.linear_velocity.y = clampf($Body.linear_velocity.y, -max, max)
	

	
	#$Body.linear_velocity = $Body.linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$Head.linear_velocity = $Head.linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"ArmInner-Left".linear_velocity = $"ArmInner-Left".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"ArmOuter-Left".linear_velocity = $"ArmOuter-Left".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"ArmInner-Right".linear_velocity = $"ArmInner-Right".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"ArmOuter-Right".linear_velocity = $"ArmOuter-Right".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"LegInner-Left".linear_velocity = $"LegInner-Left".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"LegOuter-Left".linear_velocity = $"LegOuter-Left".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"LegInner-Right".linear_velocity = $"LegInner-Right".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
	#$"LegOuter-Right".linear_velocity = $"LegOuter-Right".linear_velocity.clamp(Vector2(-max,-max),Vector2(max,max))
