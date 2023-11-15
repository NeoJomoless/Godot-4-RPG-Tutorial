extends CharacterBody2D

@export var Speed: int = 40
@export var health: int = 4
@export var knockback_strength = 100
@export var attackpow = 1
@export var radiuslimit = 80

@onready var animTree = $AnimationTree
@onready var closestEntity = $ClosestEntity
@onready var playerCollision = $PlayerCollision

var knockback_dir = Vector2.ZERO
var knockback = Vector2.ZERO
var mov_direction = Vector2()
var radius_squared = radiuslimit**2
var radius_squared_enemy = 40**2
var isfollowing = false
var enemydetected = false
var enemy = null

enum FollowerState{
	IDLE,
	ATTACK,
	CHASE,
	FOLLOW
}

var current_state = FollowerState.IDLE

signal enemy_attacked

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	if health <= 0:
		incapacitated()
	if mov_direction == Vector2.ZERO:
		animTree.get("parameters/playback").travel("Idle")
	else:
		knockback_dir = mov_direction
		animTree.get("parameters/playback").travel("Run")
	animTree.set("parameters/Idle/blend_position", mov_direction)
	animTree.set("parameters/Run/blend_position", mov_direction)
	animTree.set("parameters/Attack/blend_position", mov_direction)

	match current_state:
		FollowerState.IDLE:
			if isfollowing:
				if checkplayerdistance(player):
					animTree.get("parameters/playback").travel("Idle")
				else:
					current_state = FollowerState.FOLLOW
			else:
				animTree.get("parameters/playback").travel("Idle")
		FollowerState.ATTACK:
			if enemy != null:
				if checkenemydistance(enemy):
					move_and_slide()
					animTree.get("parameters/playback").travel("Attack")
				else:
					current_state = FollowerState.CHASE
			else:
				current_state = FollowerState.IDLE
		FollowerState.CHASE:
			if enemy == null:
				enemydetected = false
			if checkenemydistance(enemy):
				current_state = FollowerState.ATTACK
			else:
				accelerate_towards_point(enemy, delta)
				move_and_slide()
				animTree.get("parameters/playback").travel("Run")
		FollowerState.FOLLOW:
			if !checkplayerdistance(player):
				accelerate_towards_point(player, delta)
				move_and_slide()
				animTree.get("parameters/playback").travel("Run")
			else:
				current_state = FollowerState.IDLE

func checkplayerdistance(player):
	var distance_squared = (player.position.x - global_position.x)**2 + (player.position.y - global_position.y)**2
	if distance_squared <= radius_squared:
		playerCollision.target_position = player.position - global_position
		if playerCollision.is_colliding():
			return true
		else:
			return false

func checkenemydistance(enemy):
	var distance_squared_enemy = (enemy.position.x - global_position.x)**2 + (enemy.position.y - global_position.y)**2
	if distance_squared_enemy <= radius_squared_enemy:
		return true
	else:
		return false

func accelerate_towards_point(point, delta):
	var movement = mov_direction * Speed
	mov_direction = (point.position - position).normalized()
	velocity = movement + (knockback * 2)
	velocity = velocity.move_toward(mov_direction * Speed, 200 * delta)
	animTree.get("parameters/playback").travel("Run")
	animTree.set("parameters/Idle/blend_position", mov_direction)
	animTree.set("parameters/Run/blend_position", mov_direction)
	animTree.set("parameters/Attack/blend_position", mov_direction)

func incapacitated():
	print("Follower has been incapacitated.")


func _on_enemy_detector_area_entered(area):
	if area.is_in_group("Enemy"):
		enemy = area.get_parent()
		enemydetected = true
		current_state = FollowerState.CHASE


func _on_enemy_detector_area_exited(area):
	if area.is_in_group("Enemy"):
		enemydetected = false
		current_state = FollowerState.IDLE




func _on_attack_box_body_entered(body):
	if body.is_in_group("Enemy"):
		body.knockback = knockback_dir * knockback_strength
		body.health -= attackpow
