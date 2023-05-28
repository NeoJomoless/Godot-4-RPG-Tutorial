extends Control

@onready var SettingsPanel = $PopupPanel



func _on_play_pressed():
	get_tree().change_scene_to_file("res://World.tscn")


func _on_settings_pressed():
	SettingsPanel.popup_centered()

func _on_quit_pressed():
	get_tree().quit()
