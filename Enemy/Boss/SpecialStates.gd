extends Node

@onready var specialtimer = get_parent().get_node("SpecialTimer")

func Attack1():
	var Boss = get_parent()
	Boss.animTree.get("parameters/playback").travel("Special")

func _on_special_timer_timeout():
	var Boss = get_parent()
	if Boss.player_inprox:
		specialtimer.start()
		Attack1()
