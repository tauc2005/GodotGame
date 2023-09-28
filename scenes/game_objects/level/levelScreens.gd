extends Node2D

signal level_moved_down_to(position)

@onready var camera= get_node("Camera")
@onready var separator= get_node("LevelSeparator")
#@onready var levelpoints = get_node("LevelPoints")

const SCREENSIZE = 1600
var CurrentPos:int =0 : 
	get: return CurrentPos 

var CurrentScreen:int =0 : 
	get: return CurrentScreen 
	set(value):
		CurrentScreen = value
		CurrentPos = value * SCREENSIZE		
		separator.move_to_pos(CurrentPos + SCREENSIZE-3)
		camera.position.y = CurrentPos
		emit_signal("level_moved_down_to")
#
func _ready():
	CurrentScreen =0
	separator.level_move_down.connect(move_to_next_screen)
	#_separator_points = levelpoints.get_children()
	#_change_separator_position()
	#separator.level_move_down.connect(move_level_to_pos)

#------------------------------------------------
# Движение разделителя по уровню
#------------------------------------------------
func move_to_next_screen():
	CurrentScreen += 1
	
"""
func _change_separator_position():
	if (_separator_points != []):
		separator.position.y  = _separator_points[0].position.y
		_separator_points.remove_at(0) 
		#_level_points[0].delete()
		if (Globals.DEBAG): print ("(separator) moved to ",separator.position.y )
	else:
		pass	
#------------------------------------------------
# Движение камеры
#------------------------------------------------
func move_level_to_pos(position):
		
	camera.move_to_pos(position)
	_change_separator_position()
	if (Globals.DEBAG): print ("(point) moved to ",separator.position.y /1600)
	emit_signal("level_moved_down_to",position)
#------------------------------------------------
"""
