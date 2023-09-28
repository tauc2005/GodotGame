extends Camera2D

#------------------------------------------------
# Движение камеры по уровню
#------------------------------------------------
func move_to_pos(new_position):	
	self.position.y = new_position
	if (Globals.DEBAG): print ("(camera) moved to ",new_position)
"""
func move_to_next():
	if (_points !=[]):	
		_current_point = _points[0]
		position.y = _current_point
		_points.remove_at(0)
"""
