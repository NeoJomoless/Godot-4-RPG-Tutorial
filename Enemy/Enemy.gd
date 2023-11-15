extends CharacterBody2D

@export var Speed = 40
@export var health: int = 4
@export var knockback_strength = 100
@export var attackpow = 1
@export var exp_drop = 10

@onready var animTree = $AnimationTree
@onready var healthbar = $EnemyHealth

var knockback_dir = Vector2.ZERO
var knockback = Vector2.ZERO
var mov_direction = Vector2()
var see_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_parent().get_node("Player")
	animTree.active = true
	healthbar.max_value = health
	healthbar.value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		Death()
	
	if see_player == true:
		var player = get_parent().get_node("Player")
		accelerate_towards_point(player, delta)
		move_and_slide()
	else:
		animTree.get("parameters/playback").travel("Idle")
	
	knockback_dir = mov_direction
	knockback = knockback.move_toward(Vector2.ZERO, 200*delta)

func change_healthbar():
	healthbar.value = health

func accelerate_towards_point(point, delta):
	var movement = mov_direction * Speed
	mov_direction = (point.position - position).normalized()
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction * Speed, 200 * delta)
	animTree.get("parameters/playback").travel("Walk")
	animTree.set("parameters/Idle/blend_position", mov_direction)
	animTree.set("parameters/Walk/blend_position", mov_direction)



func _on_attack_detector_body_entered(body):
	if body.name == "Player":
		see_player = true


func _on_attack_detector_body_exited(body):
	if body.name == "Player":
		see_player = false

func Death():
	queue_free()
	PlayerData.exp_gain(exp_drop)


func _on_attack_box_area_entered(area):
	if area.is_in_group("Projectile"):
		var proj = get_parent().get_node("Projectile")
		if proj != null:
			health -= proj.ProjDamage
			knockback = proj.ProjKnockback * proj.movedir
			change_healthbar()
	if area.is_in_group("Melee"):
		var attacker = area.get_parent().get_parent()
		health -= attacker.attackpow
		knockback = attacker.knockback_strength * attacker.knockback_dir
		change_healthbar()
