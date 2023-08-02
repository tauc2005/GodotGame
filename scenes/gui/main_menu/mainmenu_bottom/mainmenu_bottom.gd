extends Control

signal  on_startgame_pressed()

func _on_startgame_pressed():
	print ("_on_startgame_pressed ")
	emit_signal("on_startgame_pressed")
	pass # Replace with function body.
