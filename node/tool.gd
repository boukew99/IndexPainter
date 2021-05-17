extends Node2D

enum TYPES {LINE, FILL, CIRCLE, RECTANGLE}

export var color = Color.black
export var size = 4
export(TYPES) var type
export var rounded = false
export var antialiased = true
export var fill = false


func _draw():
	match type:
		TYPES.LINE:
			draw_circle(Vector2.ZERO, size / 2, color)
		TYPES.FILL:
			draw_circle(Vector2.ZERO, size / 2, color)
		TYPES.CIRCLE:
			draw_arc(Vector2.ZERO, size / 2, 0, 2 * PI, max(2, size), color, 1, antialiased)
		TYPES.RECTANGLE:
			var center_rect = Rect2(-size / 2, -size / 2, size, size) # upgrade?
			draw_rect(center_rect, color, false, 1, antialiased)
			
			if rounded:
				draw_arc(Vector2(-size, 0), size / 2, 0, 2 * PI, size, color, 1, antialiased)
				draw_arc(Vector2(size, 0), size / 2, 0, 2 * PI, size, color, 1, antialiased)
	
