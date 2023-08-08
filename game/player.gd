extends Node
class_name PlayerItem

#Изменение данных игрока
signal on_player_data_changed(type:String,value:int)
signal start_lifetimer()
signal stop_lifetimer()

#------------------------------------------------
#------------------------------------------------
func _ready():
	if Globals.DEBAG: print ("(player) -> _ready")
	init_timer()
#------------------------------------------------
#------------------------------------------------
## Жизни
#------------------------------------------------	
var Lives:int =0 : 
	get: return Lives 
	set(value):	
		Lives = clamp(value,0,Globals.MAX_LIFES)
		if (Lives >= Globals.MAX_LIFES) :# Максимальное число жизней
			_LifeTimer.stop() 
			if Globals.DEBAG: print_debug ("(player) ->  Timer stopped")
		else: # Не максимальное число жизней 
			if Globals.DEBAG: print_debug ("(player) ->  Timer started")
			_LifeTimer.start()			
		if Globals.DEBAG: print_debug("(player) -> EMIT signal 'on_player_data_changed' - Lives, %s"%Lives)
		emit_signal("on_player_data_changed","Lives",Lives)
#------------------------------------------------		

#------------------------------------------------


#------------------------------------------------	
#------------------------------------------------	
## Таймер жизни
var _LifeTimer: Timer =null

func init_timer():
	_LifeTimer= Timer.new()
	add_child(_LifeTimer)
	_LifeTimer.autostart= false
	_LifeTimer.wait_time = Globals.TIME_TO_NEXT_LIFE
	_LifeTimer.timeout.connect(_timer_timeout)

# Таймер жизни завершился
func _timer_timeout():
	Lives +=1
	print_debug("Live Add  by Timer")

func get_timer_text():
	var res = ""
	if (Lives >= Globals.MAX_LIFES):
		res = "Все"
	else:		
		var tmp = float(_LifeTimer.time_left)
		var minute = int(tmp / 60)
		var second = int(tmp) % 60
		res = "%sм %sс" %  [int(minute),int(second)]	
	return res		
#------------------------------------------------
## Монеты
#------------------------------------------------
var Money:int =0 : 
	get: return Money 
	set(value):
		if value <0 :value =0
		Money = value		
		if Globals.DEBAG: print ("(player) -> EMIT signal 'on_player_data_changed' - Money, %s"%Money)
		emit_signal("on_player_data_changed","Money",Money)

#------------------------------------------------

#------------------------------------------------
## Уровень
#------------------------------------------------
var Level:int =1 : 
	get: return Level 
	set(value):
		if value <1 :value =1
		Level = value		
		if Globals.DEBAG: print ("(player) -> EMIT signal 'on_player_data_changed' - Level, %s"%Level)
		emit_signal("on_player_data_changed","Level",Level)
#------------------------------------------------
#------------------------------------------------


#-----------------------------------------------
## Покупка жизни
# Достаточно ли монет для покупки Жизни		
func has_money_for_life():
	if Globals.DEBAG: print("(player) ->  has_money_for_life")
	return (Money >= Globals.MONEY_FOR_LIFE)
	
# Покупка жизни за деньги
func buy_life_by_money():
	if Globals.DEBAG: print("(player) ->  buy_life_by_money")
	if (has_money_for_life()):
		Money -= Globals.MONEY_FOR_LIFE
		Lives += 1	
		return true
	return false
		
# Покупка жизни за рекламу
func buy_life_by_ads():
	if Globals.DEBAG: print("(player) ->  buy_life_by_ads")
	#TODO 
#------------------------------------------------
## Покупка ходов
# Достаточно ли монет для покупки Хода
func has_money_for_moves():
	if Globals.DEBAG: print("(player) ->  has_money_for_moves")
	return (Money >= Globals.MONEY_FOR_MOVES)
	
# Покупка Хода за деньги
func buy_moves_by_money():
	if Globals.DEBAG: print("(player) ->  buy_moves_by_money")
	if (has_money_for_moves()):
		Money -= Globals.MONEY_FOR_MOVES
		return true
	return false

# Покупка Хода за рекламу
func buy_moves_by_ads():
	if Globals.DEBAG: print("(player) ->  buy_moves_by_ads")
	#TODO 	
#------------------------------------------------
