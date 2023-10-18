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
	init_timers()
#------------------------------------------------


func init_timers():
	
	#Таймер восстановления жизни 
	_Timer_live_restore= Timer.new()
	_Timer_live_restore.autostart= false
	_Timer_live_restore.wait_time = Globals.TIME_TO_NEXT_LIFE
	_Timer_live_restore.timeout.connect(_timer_timeout)
	add_child(_Timer_live_restore)
	
	#Таймер покупки хода за деньги
	_Timer_movesByMoney= Timer.new()
	_Timer_movesByMoney.autostart= false
	_Timer_movesByMoney.wait_time = Globals.TIME_TO_CANBUY_MOVES_BY_MONEY
	_Timer_movesByMoney.timeout.connect(_on_timerMoves_byMoney_timeout)
	add_child(_Timer_movesByMoney)

	#Таймер покупки хода за  реклами
	_Timer_movesByAds= Timer.new()
	_Timer_movesByAds.autostart= false
	_Timer_movesByAds.wait_time = Globals.TIME_TO_CANBUY_MOVES_BY_ADS
	_Timer_movesByAds.timeout.connect(_on_timerMoves_byMoney_timeout)
	add_child(_Timer_movesByAds)

#------------------------------------------------
## Жизни
#------------------------------------------------	
var Lives:int =0 : 
	get: return Lives 
	set(value):	
		Lives = clamp(value,0,Globals.MAX_LIFES)
		if (Lives >= Globals.MAX_LIFES) :# Максимальное число жизней
			_Timer_live_restore.stop() 
			if Globals.DEBAG: print_debug ("(player) ->  Timer stopped")
		else: # Не максимальное число жизней 
			if Globals.DEBAG: print_debug ("(player) ->  Timer started")
			_Timer_live_restore.start()			
		if Globals.DEBAG: print_debug("(player) -> EMIT signal 'on_player_data_changed' - Lives, %s"%Lives)
		emit_signal("on_player_data_changed","Lives",Lives)
#------------------------------------------------		

#------------------------------------------------


#------------------------------------------------	
#------------------------------------------------	
## Таймер жизни
var _Timer_live_restore: Timer =null


# Таймер жизни завершился
func _timer_timeout():
	Lives +=1
	print_debug("Live Add  by Timer")

func get_timer_text():
	var res = ""
	if (Lives >= Globals.MAX_LIFES):
		res = "Все"
	else:		
		var tmp = float(_Timer_live_restore.time_left)
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
#-----------------------------------------------
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
#------------------------------------------------
var canBuyMoves_byMoney:bool = true
var _Timer_movesByMoney :Timer

func _on_timerMoves_byMoney_timeout():
	if Globals.DEBAG: print("(player) ->  _on_timerMoves_byMoney_timeout")
	canBuyMoves_byMoney = true
	_Timer_movesByMoney.stop()
	
	
# Достаточно ли монет для покупки Хода
func has_money_for_moves():
	if Globals.DEBAG: print("(player) ->  has_money_for_moves")
	return (canBuyMoves_byMoney and(Money >= Globals.MONEY_FOR_MOVES))
	
# Покупка Хода за деньги
func buy_moves_by_money():
	if Globals.DEBAG: print("(player) ->  buy_moves_by_money")
	if (has_money_for_moves()):
		Money -= Globals.MONEY_FOR_MOVES
		Rules.add_moves(Globals.MOVES_BY_MONEY)
		canBuyMoves_byMoney = false
		_Timer_movesByMoney.start()
		return true
	return false	

#------------------------------------------------
var canBuyMoves_byAds:bool = true
var _Timer_movesByAds :Timer

func _on_timerMoves_byAds_timeout():
	if Globals.DEBAG: print("(player) ->  _on_timerMoves_byAds_timeout")
	canBuyMoves_byAds = true
	_Timer_movesByAds.stop()
	
func has_ads_for_moves():
	return (canBuyMoves_byAds)
# Покупка Хода за рекламу
func buy_moves_by_ads():
	if Globals.DEBAG: print("(player) ->  buy_moves_by_ads")
	if canBuyMoves_byAds:	
		#TODO  
		# Показ рекламы
		Rules.add_moves(Globals.MOVES_BY_ADS)
		canBuyMoves_byMoney = false
		_Timer_movesByMoney.start()
		return true
	return false	
#------------------------------------------------
func add_bonuses():
	var bonuses = Loader.get_level_data("bonus")
	for item in bonuses:
		var value = bonuses[item]
		match item:
			"money": Money += value
	pass
