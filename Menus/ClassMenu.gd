extends Control


func chose_class(classnum):
	PlayerData.Class = classnum
	get_tree().change_scene_to_file("res://World.tscn")


func _on_mage_pressed():
	chose_class(0)


func _on_warrior_pressed():
	chose_class(1)


func _on_thief_pressed():
	chose_class(2)
