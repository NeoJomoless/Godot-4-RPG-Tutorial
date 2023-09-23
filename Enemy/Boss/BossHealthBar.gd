extends CanvasLayer

@onready var HealthProg = $ProgressBar
@onready var BossName = $RichTextLabel

func _ready():
	var Boss = get_parent().get_node("Boss")
	Boss.bosshealth_changed.connect(change_healthbar)
	Boss.sethealthbar.connect(set_healthmax)
	Boss.setname.connect(setname)
	show_healthbar()

func setname(string):
	BossName.text = string

func set_healthmax(value):
	HealthProg.max_value = value

func change_healthbar(value):
	HealthProg.value = value

func show_healthbar():
	$AnimationPlayer.play("fade in")

func hide_healthbar():
	$AnimationPlayer.play("fade out")

func _process(_delta):
	if HealthProg.value <= 0:
		hide_healthbar()
		$Timer.start()


func _on_timer_timeout():
	queue_free()
