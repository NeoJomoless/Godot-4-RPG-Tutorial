extends CanvasLayer


func _on_follow_pressed():
	get_parent().get_parent().isfollowing = true


func _on_dismiss_pressed():
	get_parent().get_parent().isfollowing = false


func _on_exit_pressed():
	queue_free()
