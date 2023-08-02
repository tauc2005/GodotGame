extends CanvasLayer
class_name SceneManager
## Класс SceneManager занимается отображением окон приложении

# GUI
@onready var ui_mainMenu = get_node("GUI/MainMenu")
@onready var ui_gameMenu = get_node("GUI/GameMenu")
@onready var wnd_settings = get_node("GUI/Modals/Settings")


# Called when the node enters the scene tree for the first time.
func _ready():
	#Связываем сигналы
	ui_mainMenu.on_show_gui_window.connect(show_window)
	ui_gameMenu.on_show_gui_window.connect(show_window)
	wnd_settings.on_window_closed.connect(hide_window.bind("settings"))
	#ui_mainMenu_bottom.on_startgame_pressed.connect(show_gui_window.bind("game"))
	
	pass # Replace with function body.


#------------------------------------------------
# Навигация между окнами
#------------------------------------------------
func show_window(name:String):
	print ("(SceneManager)   -> show_window("+name+")")
	match name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		"settings": wnd_settings.visible = true
	pass

func show_main():
	ui_mainMenu.visible = true
	ui_gameMenu.visible = false
	pass
	
func show_game():
	ui_mainMenu.visible = false
	ui_gameMenu.visible = true
	pass

func hide_window(name:String):
	print ("(SceneManager)   -> hide_window("+name+")")
	match name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		"settings":  wnd_settings.visible = false
	pass
