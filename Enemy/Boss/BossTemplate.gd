extends CharacterBody2D

@export var Speed = 40
@export var health: int = 4
@export var knockback_strength = 100
@export var attackpow = 1
@export var exp_drop = 100
@export var Boss_Name = ""

@onready var animPlayer = $AnimationPlayer
@onready var animTree = $AnimationTree
@onready var specialtimer = $SpecialTimer

var knockback_dir = Vector2.ZERO
var knockback = Vector2.ZERO
var mov_direction = Vector2()
var see_player = false
var player_inprox = false

signal bosshealth_changed
signal sethealthbar(value)
signal setname(string)

func _ready():
	var player = get_parent().get_node("Player")
	player.enemy_attacked.connect(change_healthbar)
	emit_signal("sethealthbar", health)
	emit_signal("setname", Boss_Name)
	emit_signal("bosshealth_changed", health)
	animTree.active = true

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
	emit_signal("bosshealth_changed", health)

func accelerate_towards_point(point, delta):
	var movement = mov_direction * Speed
	mov_direction = (point.position - position).normalized()
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction * Speed, 200 * delta)
	if !player_inprox:
		animTree.get("parameters/playback").travel("Walk")
	animTree.set("parameters/Idle/blend_position", mov_direction)
	animTree.set("parameters/Walk/blend_position", mov_direction)
	animTree.set("parameters/Special/blend_position", mov_direction)

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
			proj.enemy_attacked.connect(change_healthbar)


func _on_attack_prox_body_entered(body):
	if body.name == "Player":
		player_inprox = true


func _on_attack_prox_body_exited(body):
	if body.name == "Player":
		player_inprox = false


func _on_special_timer_timeout():
	if player_inprox:
		specialtimer.start()
		animTree.get("parameters/playback").travel("Special")
