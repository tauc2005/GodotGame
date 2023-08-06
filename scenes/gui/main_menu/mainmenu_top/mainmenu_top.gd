extends Control

signal  on_show_settings_pressed()

func _on_setting_button_pressed():
	print ("(mainmenu_top) _on_setting_button_pressed ")
	emit_signal("on_show_settings_pressed")
	pass # Replace with function body.
