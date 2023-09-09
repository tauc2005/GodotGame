extends Control
#--------------------------------------
## GAME MENU TOP
#--------------------------------------
# Навигация
signal  on_backtomain_pressed()
signal  on_show_settings_pressed()

func _on_backtomain_pressed():
	print ("(gamemenu_top) _on_backtomain_pressed ")
	emit_signal("on_backtomain_pressed")
func _on_setting_button_pressed():
	print ("(mainmenu_top) _on_setting_button_pressed ")
	emit_signal("on_show_settings_pressed")
#--------------------------------------
# Правила победы
@onready var RuleBox = get_node("CenterContainer/HBoxContainer/MarginContainer2/NinePatchRect/HBoxContainer/MarginContainer2/rules/") 

@onready var  _rules = {
	1: RuleBox.get_node("rule1"),
	2: RuleBox.get_node("rule2"),
	3: RuleBox.get_node("rule3")
}
@onready var moves = get_node("CenterContainer/HBoxContainer/MarginContainer2/NinePatchRect/HBoxContainer/MarginContainer/moves/moves_value")

func _ready():
	for i in _rules:
		Rules.Values[i].data_changed.connect(_rules[i].update_item)
	Rules.on_moves_changed.connect(set_moves)
		
#------------------------------------------------
# Ходы
#------------------------------------------------
# Устанавливаем данные по ходам
func set_moves(value):
	moves.text = str( value)
#------------------------------------------------
# Условия победы
#------------------------------------------------
func init_rules():
	var rule_data = Loader.get_level_data("rules")
	if (not rule_data):
		print_debug("Ошибка формирования правил уровня")
	for rule in rule_data:
		print (rule)
	
	
# Устанавливаем данные по правилам
func set_rule(number,type,value):
	_rules[number].set_type(type,value)

# Обновить данные по правилам
func update_rule(number,value):
	_rules[number].set_value(value)	

# Сброс значений todo
func reset ():
	for i in _rules:	
		_rules[i].set_value(0)
#------------------------------------------------		
	
