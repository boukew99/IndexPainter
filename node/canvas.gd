extends ColorRect

signal painted
onready var tool2 = $Tool

onready var draws := [{"positions" : [], "size" : tool2.size, "color" : tool2.color, "type" : tool2.type, "fill" : tool2.fill, "rounded" : tool2.rounded, "antialiased" : tool2.antialiased}] # strokes = draws.size()
var grid = Vector2(0, 0) 
var index := 0

var drawing := false
var snap := false

enum {LINE, PRIMITVE, ECLIPSE}

func _on_Canvas_gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		drawing = true
		if snap:
			var cell_size = rect_size / grid
			var cell = (event.position / cell_size).round()
			draws[index]["positions"].append(cell * cell_size)
		else:
			draws[index]["positions"] = [event.position]
		update()
		
	if event is InputEventMouseMotion:
		if drawing and get_rect().has_point(event.position):
			if snap:
				var cell_size = rect_size / grid
				var cell = (event.position / cell_size).round()
				draws[index]["positions"].append(cell * cell_size)
			else:
				draws[index]["positions"].append(event.position)
			
			update()
			
		tool2.position = event.position
		tool2.update() # draw tool
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		drawing = false
		if draws.size() - 1 == index:
			var stroke = {"positions" : [], "size" : tool2.size, "color" : tool2.color, "type" : tool2.type, "fill" : tool2.fill, "rounded" : tool2.rounded, "antialiased" : tool2.antialiased}
			draws.append(stroke)
			index += 1
			emit_signal("painted")
			

func _draw():
	for stroke in draws:
		if stroke["positions"].size() > 1: 
			match stroke["type"]:
				LINE:
					if stroke["fill"]: fill(stroke["positions"], stroke["size"], stroke["color"], stroke["antialiased"])
					draw_polyline(stroke["positions"], stroke.color, stroke.size, stroke["antialiased"])
				PRIMITVE:
					draw_line(stroke["positions"][0], stroke["positions"][-1], stroke.color, stroke.size, stroke["antialiased"])
				ECLIPSE:
					pass
					# place circle with hold (start = pos, end.length = radius, end.dir = rotation)
					# somehow do scale
					# then covered angles of line
					# perhaps include this in a ruler instead of brush type
			
			if stroke.rounded: roundends(stroke["positions"][0], stroke["positions"][-1], stroke["size"], stroke["color"])
				
	if grid:
		var cell_size = rect_size / grid
		for x in grid.x:
			draw_line(Vector2(cell_size.x * x, 0), Vector2(cell_size.x * x, rect_size.y), Color.white) # vertical lines
		for y in grid.y:
			draw_line(Vector2(0, cell_size.y * y), Vector2(rect_size.x, cell_size.y * y), Color.white) # horizontal lines 
	
	
	if index != draws.size() - 1:
		var positions = draws[index]["positions"]
		
		if positions.size() > 2:
			draw_polyline(positions, Color.red, 2)
		elif positions.size() == 1:
			draw_circle(positions[0], 1, Color.red)
		
		
			
func roundends(begin, end, size, color): # or pop_back? 
	var circle_size = size / 2.0 
	draw_circle(begin, circle_size, color)
	draw_circle(end, circle_size, color)

func fill(positions, size, color, antialiased):
	var circle_size = size / 2.0  # radius / 2
	var first_position = positions[0]
	
	for position in positions:
		draw_line(first_position, position, color, circle_size, antialiased)


