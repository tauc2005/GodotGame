extends CanvasLayer
class_name SceneManager
## Класс SceneManager занимается отображением окон приложении

# Сигнал на запуск игры
signal on_game_start()
signal on_game_end()

# GUI
@onready var ui_mainMenu = get_node("GUI/MainMenu")
@onready var ui_gameMenu = get_node("GUI/GameMenu")
@onready var wnd_settings = get_node("GUI/Modals/Settings")
# Показываем условия победы и призы 
@onready var wnd_before_game = get_node("GUI/Modals/GameBefore")
# Окно проигрыша
@onready var wnd_game_loose = get_node("GUI/Modals/LevelLoose")
# Окно победы
@onready var wnd_game_win= get_node("GUI/Modals/GameWin")
# Окно покупки доп хода
@onready var wnd_buy_moves= get_node("GUI/Modals/BuyMoves")


#Счетчик окон при поражении

var _game_status = Globals.GAME_STATUS.NONE
var _buy_moves_showen :bool = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Связываем сигналы
	ui_mainMenu.on_show_gui_window.connect(show_window)
	ui_gameMenu.on_show_gui_window.connect(show_window)

	# Окно настроек
	wnd_settings.on_window_closed.connect(hide_window.bind("settings"))
	
	# Окно перед стартом игры
	wnd_before_game.on_window_closed.connect(hide_window.bind("before_game"))
	wnd_before_game.on_game_start.connect(_on_game_start)
	
	# Завершение уровня
	Rules.on_level_complited.connect(_on_level_complited)	
	
	# Окно выигрыша
	wnd_game_win.on_window_closed.connect   (hide_window.bind("game_win"))
	#wnd_game_win.on_game_complite.connect (_on_game_complite)

	# Окно покупки ходов
	wnd_buy_moves.on_window_closed.connect (hide_window.bind("buy_moves"))
	wnd_buy_moves.on_return_to_game.connect(hide_window.bind("buy_moves"))
		
	# Окно проигрыша	
	wnd_game_loose.on_level_complited.connect(_on_level_complited)
	wnd_game_loose.on_window_closed.connect (hide_window.bind("game_loose"))		

#------------------------------------------------
## Навигация между окнами
#------------------------------------------------
func show_window(wnd_name:String):
	print ("(SceneManager)   -> show_window("+wnd_name+")")
	match wnd_name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		# Модальные окна
		"settings":    wnd_settings.visible = true
		"before_game": wnd_before_game.visible = true
		"game_loose" : wnd_game_loose.visible = true
		"game_win"	 : wnd_game_win.visible = true
		"buy_moves"	 : wnd_buy_moves.visible  = true
	pass
	
func hide_window(wnd_name:String):
	print ("(SceneManager)   -> hide_window("+wnd_name+")")
	match wnd_name:
		"": printerr("(SceneManager)   -> show_window - empty param! ")
		"main": show_main()
		"game": show_game()
		"settings":  wnd_settings.visible = false
		"before_game": wnd_before_game.visible = false
		"game_loose" : 
			wnd_game_loose.visible = false
			show_main()
		"game_win"	 : 
			wnd_game_win.visible = false
			show_main()
		"buy_moves"	 : 
			wnd_buy_moves.visible  = false
			_buy_moves_showen =true
	pass	
#------------------------------------------------
func show_main():
	ui_mainMenu.visible = true
	ui_gameMenu.visible = false
	_on_game_ended()
	pass
	
func show_game():
	ui_mainMenu.visible = false
	ui_gameMenu.visible = true
	#_game_status = Globals.GAME_STATUS.GAME
	pass

#------------------------------------------------
# Запуск игры
#------------------------------------------------
func _on_game_start():
	if Globals.DEBAG:print ("(SceneManager)   -> _on_game_start")
	emit_signal("on_game_start")
	_game_status = Globals.GAME_STATUS.GAME

func _on_game_ended():
	emit_signal("on_game_end")
	_game_status = Globals.GAME_STATUS.NONE

#------------------------------------------------

#------------------------------------------------
## Изменение игровых данных
#------------------------------------------------
## Изменениие данных игрока
func player_changed(type:String,value:int):
	if Globals.DEBAG:print ("(SceneManager)   player_changed ->%s (%d)" % [type,value])
	match type:
		"Lives": ui_mainMenu.update(type,value)
		"Money": ui_mainMenu.update(type,value)
		"Level": wnd_before_game.Level = value
#------------------------------------------------
# Изменились данные игры
func level_data_changed():
	if Globals.DEBAG:print ("(SceneManager)   level_data_changed ")
	pass
#------------------------------------------------
# Уровень пройден
func _on_game_win():
	show_window("game_win")

func _on_game_lose():
	_game_status = Globals.GAME_STATUS.LOSE	
	show_window("game_loose")	
	_buy_moves_showen = false

func _check_game_status(result:bool):
	if (_game_status == Globals.GAME_STATUS.NONE):
		return
	if result:
		_game_status = Globals.GAME_STATUS.WIN
	else: 
		if (Player.has_money_for_moves() or Player.has_ads_for_moves()):
			if (not _buy_moves_showen):
				_game_status = Globals.GAME_STATUS.TRY_AGAIN
			else:	
				_game_status = Globals.GAME_STATUS.LOSE
		else:
			_game_status = Globals.GAME_STATUS.LOSE
			
# Показ окна в зависимости от наличия денег, просмотренной рекламы	
func _on_level_complited(result:bool):
	if Globals.DEBAG: 
		print ("(SceneManager) -> _on_level_complited %s" % result) 
	_check_game_status(result)
	
	match _game_status:
		Globals.GAME_STATUS.WIN: # Уровень пройден
			_on_game_win()			
		Globals.GAME_STATUS.LOSE:  # проигрыш
			_on_game_lose()
		Globals.GAME_STATUS.TRY_AGAIN:	# Есть возможность купить ходы
			if (not _buy_moves_showen) :
				show_window("buy_moves")
			else:
				_on_game_lose()
	

