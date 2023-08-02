extends Control

signal  on_show_settings_pressed()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_setting_button_pressed():
	print ("(mainmenu_top) _on_setting_button_pressed ")
	emit_signal("on_show_settings_pressed")
	pass # Replace with function body.
