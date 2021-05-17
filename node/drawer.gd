extends Button


func _on_Drawer_toggled(button_pressed):
	var next_parent_position = get_position_in_parent() + 1
	var parent = get_parent()
	for child_index in range(next_parent_position , parent.get_child_count()):
		parent.get_child(child_index).visible = button_pressed
	
	if button_pressed:
		text = "<"
	else:
		text = ">"
