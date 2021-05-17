tool
class_name MaxSpinBox
extends SpinBox

export var maximum := 100 setget set_maximum
func set_maximum(value):
	maximum = value
	max_value = value
	suffix = "/ " + str(max_value)
