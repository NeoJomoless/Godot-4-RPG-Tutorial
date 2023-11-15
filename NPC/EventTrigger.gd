extends Area2D

var NPCMenu = load("res://Menus/NPCMenu.tscn")

@onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	player.follower_interacted.connect(instanceNPCMenu)


func instanceNPCMenu():
	if get_parent().get_node("MenuAnchor").get_child(0) == null:
		var instance = NPCMenu
		var spawn = instance.instantiate()
		get_parent().get_node("MenuAnchor").add_child(spawn)
