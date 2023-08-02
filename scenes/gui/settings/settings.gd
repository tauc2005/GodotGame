extends Control


signal  on_window_closed()

func _on_window_closed():
	print ("(settings) _on_window_closed ")
	emit_signal("on_window_closed")
	pass # Replace with function body.
