extends Node

#export var sfx_level_complete:AudioStream

@export var current_level:int = 0
var is_paused: bool = false

var can_pause:bool = true

@export var levels: Array[PackedScene]
@export var last_level:PackedScene
@export var title_level:PackedScene

#----------------------------------------------------------
# FADE PROPERTIES
enum FADE_TYPE {fadeOut, fadeIn, none}
@onready var _anim_fade:AnimationPlayer = $AnimFade
@onready var _control:Control = $CanvasLayer/Control
@onready var _colorRect:ColorRect = $CanvasLayer/Control/ColorRect

#--------------- AUDIO PROPERTIES--------------------
@onready var _audio_bgm:AudioStreamPlayer = $BGM
@onready var _audio_bgs:AudioStreamPlayer = $BGS

@onready var _audio_sfx01:AudioStreamPlayer = $Sfx01
@onready var _audio_sfx02:AudioStreamPlayer = $Sfx02
@onready var _audio_sfx03:AudioStreamPlayer = $Sfx03

@export var audio_sfxArray: Array[AudioStreamPlayer]

var _sfx_counter:int = 0 #used to play the next buffer
# ---------------------------------------------------

@onready var death_animation:AnimationPlayer = $DeathAnimation/AnimationPlayer


var playerHead: Node2D

var is_world_paused:bool
var _death_subtext:String

var dodgeArrows: int = 0
var gameOver: bool = false

#PLAYER INFO : HARDCODED IN!
#var player:KinematicBody2D

func clearLater(givenNode: Node2D):
	
	return
	
	await get_tree().create_timer(15.0).timeout	
	#if (givenNode):
	givenNode.queue_free()

func _ready():
	#_control.visible = false
	print(get_tree().get_current_scene().get_name())

	#if (get_tree().current_scene. == "Title"):
		#return
func _process(delta):
	

	if Input.is_key_pressed(KEY_R):
		reset_level()
		#get_tree().reload_current_scene()
		#Engine.time_scale = 1.0
	#if Input.is_action_just_released("ui_reset"):
		#reset_level(false)
		
	if Input.is_action_just_released("ui_esc"):
		_audio_bgm.stop()
		get_tree().change_scene_to_file("res://scenes/Title.tscn")
		#current_level = 0
		
	if Input.is_action_just_pressed("Left") || Input.is_action_just_pressed("Right"):
		if (gameOver):
			reset_level()
			#gameOver = false
			#get_tree().reload_current_scene()
			#Engine.time_scale = 1.0
		
	#if Input.is_action_just_released("ui_next"):
		#next_level()
		#
	#if Input.is_action_just_pressed("start"):
	#get_tree().change_scene("res://Scene/UI/TitleScreen.tscn")		

#func camera_shake():
	#pass
	#
func game_over():
	
	Engine.time_scale = 0.5
	await get_tree().create_timer(2).timeout
	gameOver = true
	
	#Engine.time_scale = 1.0
	#get_tree().reload_current_scene()
	
	$CanvasLayer/Control.visible = true
	#$CanvasLayer/Control/Score.visible = true
	$CanvasLayer/Control/Score/scoreLbl.text = "[center]%s[/center]" % str(dodgeArrows)
	
	
func reset_level():
	$CanvasLayer/Control.visible = false
	gameOver = false
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	dodgeArrows = 0
	playerHead = null

func next_level():
	
	is_world_paused = true
	current_level += 1
	
	var scene
	
	if current_level >= levels.size():
		scene = last_level
			
	else:
		scene = levels[current_level]	
		
	#IF END SCENE
	if (get_tree().get_current_scene().get_name() == "End"):
		scene = title_level
	
	change_scenePacked(scene)

#func reset_level(has_died):
	#if has_died:
		#_death_subtext = "Death"
	#else:
		#_death_subtext = ""
	#
	#is_world_paused = true
	#var scene = levels[current_level]
	#change_scenePacked(scene)
	
	
func change_scene(scene_path:String, transition:int = 0):
	get_tree().change_scene(scene_path)
	
func change_scenePacked(scene:PackedScene, transition:int = 0):	
	
	_control.visible = true
	_anim_fade.play("FadeIn" + _death_subtext)
	
	#yield(_anim_fade, "animation_finished")	
	#yield(get_tree().create_timer(0.25), "timeout")
	
	get_tree().change_scene_to(scene)	
	_anim_fade.play("FadeOut" + _death_subtext)
	
	# GAIN BACK CONTROl
	reset_world();	
	is_world_paused = false
	_anim_fade.playback_speed = 1

	
	#yield(_anim_fade, "animation_finished")	
	_control.visible = false
	
func reset_world():
	pass
	
func play_music(music : AudioStream, fade_dur: float = 0):
	
	if _audio_bgm.stream == music:
		return
		
	_audio_bgm.stream = music
	_audio_bgm.play()
	pass
	
func fadeout_music(fade_dur: float):
	pass

func play_sfx(sfx : AudioStream):
	
	var player:AudioStreamPlayer
	
	player = audio_sfxArray[_sfx_counter]
	
	#match _sfx_counter:
		#0: player = _audio_sfx01
		#1: player = _audio_sfx02
		#2: player = _audio_sfx03
		
	_sfx_counter += 1
	if _sfx_counter > audio_sfxArray.size()-1:
		_sfx_counter = 0
		
	player.stream = sfx
	player.play()

	pass
	
func pause(val:bool):
	can_pause = !val
	get_tree().paused = val	
	
func pause_actors(val: bool) -> void:
	get_tree().call_group("Actors", "Pause")
	pass
	

func death(pos: Vector2):
	death_animation.get_parent().global_position = pos
	death_animation.play("death")
	
