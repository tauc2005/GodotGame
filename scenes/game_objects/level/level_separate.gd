extends Area2D
signal level_move_down()
const node_type = "level_separator"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if body.has_method("get_type"):
		#if body.get_type()in ("ball","ice","stone"):
		print("(LevelSeparator) прошло разделитель уровня: ", body.get_type())
		emit_signal("level_move_down")
	pass # Replace with function body.

func move_to_pos(new_position):	
	self.position.y = new_position
	if (Globals.DEBAG): print ("(separator) moved to ",new_position)
