extends Node



# Called when the node enters the scene tree for the first time.
@onready var GUI = get_node("SceneManager")
@onready var Game = get_node("Game")


func _ready():
	if Globals.DEBAG: print ("(main)   -> _ready ")
	GUI.on_game_start.connect(_on_game_start)
	GUI.on_game_end.connect(_on_game_end)
	
	# GUI  и данные игрока
	Player.on_player_data_changed.connect(GUI.player_changed)
	
	Loader.load_userdata()
	if Loader.load_level_data(Player.Level):
		Rules.reset_data()
	
	
	Game.level_data_changed.connect(_on_level_data_changed)
	Rules.on_level_complited.connect(_on_level_complite)
	pass
	

#------------------------------------------------
# СТАРТ ИГРЫ	
#------------------------------------------------
func _on_game_start():
	if Globals.DEBAG: print ("(main)   -> _on_game_start ")
	Game.startGame()
	#Отображение игрового интерфейса
	GUI.show_game()

func _on_game_end():
	if Globals.DEBAG: print ("(main)   -> _on_game_end ")
	Game.exitGame()

# Таймер жизни сделал расчет
func _on_lifeTimer_finnished():
	Player.Lives +=1 

# Изменение игрового прогресса
func _on_level_data_changed():
	GUI.level_data_changed()
	pass
# Игра завершилась. Обработка только успеха
func _on_level_complite(_result):
	if not _result: return 
	if Globals.DEBAG: print ("(main) -> _on_level_complite %s "% _result) 
	print ("----BONUS---")
	Player.Lives +=1 
