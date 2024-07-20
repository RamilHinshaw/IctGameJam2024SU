extends Node2D




@export var power = 200
@export var upwardPower = 100
@export var bonusForce = 150000
@export var jumpForce = 200000

@export var lastInputTimerMin = 0.2
@export var lastJumpInputTimerMin = 0.04

var _lastInputTime: float = 0
var _lastInputAxis: float = 0

var _isLeftHeld: bool
var _isRightHeld: bool

var _isAirborne: bool = false


func _physics_process(delta):
	var axis = Input.get_action_strength("Right") - Input.get_action_strength("Left")	
	var force: Vector2 = Vector2.UP * upwardPower + Vector2.RIGHT * axis * power
	
	_isAirborne = !$Body.position.y >= 240
	#print("AIRBORNE: " + str(_isAirborne))
	
	print($Body.position.y)
		
		
	if Input.is_action_just_pressed("Left") || Input.is_action_just_pressed("Right"):
		
		var lastInputDelay = (Time.get_ticks_msec() - _lastInputTime)/1000
		print(lastInputDelay)
			
		if lastInputDelay <= lastInputTimerMin:
			print("Fast Input detected!")
			
			if (_lastInputAxis == axis):
				$Body.apply_central_force(Vector2.RIGHT * axis * bonusForce + Vector2.UP * bonusForce/8)
				print("DASH")
			
		if ((_lastInputAxis != axis && lastInputDelay <= lastJumpInputTimerMin) ||
		 (axis == 0 && !_isLeftHeld && !_isRightHeld)):
			
			if (!_isAirborne):
				#$Body.apply_central_force(Vector2.UP * bonusForce*2)
				$"ArmOuter-Right".apply_central_force(Vector2.UP * jumpForce*2)
				$"ArmOuter-Left".apply_central_force(Vector2.UP * jumpForce*2)
				print("JUMP")
		
		
		# Reset
		_lastInputTime = Time.get_ticks_msec()
		_lastInputAxis = axis
		
		
	#If on ground
	$Body.apply_impulse(Vector2.RIGHT * axis * power,Vector2.ZERO)
	
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
		

