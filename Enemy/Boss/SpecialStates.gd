extends Node

@onready var specialtimer = get_parent().get_node("SpecialTimer")

func Attack1():
	var Boss = get_parent()
	Boss.animTree.get("parameters/playback").travel("Special")

func select_random_attack():
	var rng = RandomNumberGenerator.new()
	var random_selection = rng.randi_range(0, 2)
	if random_selection == 0:
		Attack1()
	elif random_selection == 1:
		print("Attack 2")
	else:
		print("Attack 3")

func select_attack_conditional():
	var Boss = get_parent()
	var max_health = Boss.max_health
	var curhealth = Boss.health
	var calchealth: float = float(curhealth) / float(max_health)
	Attack1()
	if calchealth <= 0.5:
		select_random_attack()
	elif calchealth <= .25:
		pass

func _on_special_timer_timeout():
	var Boss = get_parent()
	if Boss.player_inprox:
		specialtimer.start()
		select_random_attack()
