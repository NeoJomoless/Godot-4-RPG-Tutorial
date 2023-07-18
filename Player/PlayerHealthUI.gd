extends CanvasLayer

var hearts = 4
var maxhearts = 4
@onready var player = get_parent().get_node("Player")
@onready var HealthEmpty = $HealthUIEmpty
@onready var HealthFull = $HealthUIFull

func _ready():
	if player != null:
		player.health_changed.connect(change_texture)

func change_texture(value):
	hearts = value
	if hearts >= 0:
		if hearts <= maxhearts:
			HealthFull.size.x = hearts * 32
