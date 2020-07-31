extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !get_tree().paused
		get_tree().paused = !get_tree().paused


func _on_ResumeButton_pressed():
	get_tree().paused = false
	self.visible = false


func _on_RestartButton_pressed():
	assert(get_tree().reload_current_scene() == OK)
	get_tree().paused = false
	self.visible = false


func _on_MenuButton_pressed():
	assert(get_tree().change_scene("res://Menu/Menu.tscn") == OK)
	get_tree().paused = false
	self.visible = false
