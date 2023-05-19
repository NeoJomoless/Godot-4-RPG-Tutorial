extends CharacterBody2D
@onready var animated_sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var animTree = $AnimationTree
@export var Speed: int = 50
@export var Friction: float = 0.15
@export var Acceleration: int = 40

var is_moving = false
var is_attacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_attacking == false:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
		input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up") 
		
		velocity = input_vector * Speed
		
		if input_vector == Vector2.ZERO:
			animTree.get("parameters/playback").travel("Idle")
		else:
			animTree.get("parameters/playback").travel("Run")
			animTree.set("parameters/Idle/blend_position", input_vector)
			animTree.set("parameters/Run/blend_position", input_vector)
			animTree.set("parameters/Attack1/blend_position", input_vector)
		move_and_slide()
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		animTree.get("parameters/playback").travel("Attack1")

func finished_attacking():
	is_attacking = false

