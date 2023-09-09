extends Control


signal  on_window_closed()

func _on_window_closed():
	if Globals.DEBAG: print ("(settings) _on_window_closed ")
	emit_signal("on_window_closed")
	pass # Replace with function body.


func _on_bg_focus_entered():
	emit_signal("on_window_closed")
	pass # Replace with function body.
