extends Control

signal  on_show_settings_pressed()

@onready var LifeHolder  = get_node("MarginContainer/NinePatchRect/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/LIFEContainer/LifeHolder")
@onready var MoneyHolder = get_node("MarginContainer/NinePatchRect/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/MONEYContainer/MoneyHolder")
#------------------------------------------------
func _on_setting_button_pressed():
	print ("(mainmenu_top) _on_setting_button_pressed ")
	emit_signal("on_show_settings_pressed")
	pass # Replace with function body.
#------------------------------------------------
# Установить в GUI значение жизней
func set_lives(value:int ):
	LifeHolder.Lives = value
	pass
# Установить в GUI значение монет	
func set_money(value:int ):
	MoneyHolder.Money = value
	pass
#------------------------------------------------
func _process(delta):
	#if (delta >=1):
	LifeHolder.TimerLife = Player.get_timer_text()
