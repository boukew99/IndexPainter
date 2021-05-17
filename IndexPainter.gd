extends Control

onready var canvas = $VBoxContainer/Layers/Canvas
onready var tool2 = canvas.get_node("Tool")

func _ready():
	VisualServer.set_default_clear_color($VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Background.color)
	
	# color popups
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Color.get_picker().get_parent().input_pass_on_modal_close_click = false
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Background.get_picker().get_parent().input_pass_on_modal_close_click = false
	
	
func _on_Type_item_selected(index):
	tool2.type = index
	tool2.update()
	canvas.draws[canvas.index]["type"] = index
	canvas.update()


func _on_Color_color_changed(color):
	tool2.color = color
	tool2.update()
	canvas.draws[canvas.index]["color"] = color
	canvas.update()


func _on_Size_value_changed(value):
	tool2.size = value
	tool2.update()
	canvas.draws[canvas.index]["size"] = value
	canvas.update()


func _on_Fill_toggled(button_pressed):
	tool2.fill = button_pressed
	tool2.update()
	canvas.draws[canvas.index]["fill"] = button_pressed
	canvas.update()


func _on_Rounded_toggled(button_pressed):
	tool2.rounded = button_pressed
	tool2.update()
	canvas.draws[canvas.index]["rounded"] = button_pressed
	canvas.update()


func _on_Antialiased_toggled(button_pressed):
	tool2.antialiased = button_pressed
	tool2.update()
	canvas.draws[canvas.index]["antialiased"] = button_pressed
	canvas.update()


func _on_X_value_changed(value):
	canvas.grid.x = value
	canvas.update()

func _on_Y_value_changed(value):
	canvas.grid.y = value
	canvas.update()
	

func _on_Index_value_changed(value):
	canvas.index = value
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Type.selected = canvas.draws[value]["type"]
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Color.color = canvas.draws[value]["color"]
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Size.value = canvas.draws[value]["size"]
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Fill.pressed = canvas.draws[value]["fill"]
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Rounded.pressed = canvas.draws[value]["rounded"]
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Antialiased.pressed = canvas.draws[value]["antialiased"]
	canvas.update()


func _on_Canvas_painted():
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Index.maximum = canvas.draws.size() - 1
	$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Index.value = canvas.index


func _on_Background_color_changed(color):
	VisualServer.set_default_clear_color(color)


func _on_Delete_pressed():
	if canvas.index == 0:
		canvas.draws[canvas.index]["positions"] = []
		canvas.update()
#	elif canvas.index == canvas.draws.size() - 1:
#		canvas.draws.remove(canvas.index - 1)
#		canvas.index -= 1
#		$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Index.maximum = canvas.draws.size() - 1
		canvas.update()
	elif canvas.index > 0:
		canvas.draws.remove(canvas.index)
		canvas.index -= 1
		$VBoxContainer/Toolbar/ScrollContainer/HBoxContainer/Tool/Index.maximum = canvas.draws.size() - 1
		canvas.update()
		

func _on_Export_pressed():
	$SaveDialog.popup_centered()
	
func _on_SaveDialog_file_selected(path):
	yield(VisualServer, "frame_post_draw")

	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	
	
	var cropped_image = img.get_rect(canvas.get_rect())
	cropped_image.save_png(path)


func _on_Information_pressed():
	$Information.popup_centered()


func _on_Snap_toggled(button_pressed):
	canvas.snap = button_pressed
