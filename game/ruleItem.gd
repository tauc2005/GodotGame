extends Object
class_name RuleItem
signal data_changed(item)
signal type_changed(item) 
signal data_init(item) 

# Тип правила
var Type = Globals.RULE_TYPE:
	get: 
		return Type
	set(new_type): 
		Type = new_type
		emit_signal("type_changed",self)
		
# Стартовое значение
var Default:int=0
# Текущее значение
var Value:int:
	get:
		return Value
	set(new_value):
		Value = new_value
		emit_signal("data_changed",self)
#-----------------
func _ready():
	pass # Replace with function body.
#-----------------
func _init (rule_type:Globals.RULE_TYPE=Globals.RULE_TYPE.NONE, _value:int=0):#,_target=0):
	set_data(rule_type,_value)
	
#-----------------	
# Сброс пройденного прогресса
func reset():
	Value = Default
	
func set_data(rule_type:Globals.RULE_TYPE, _value:int):
	Type = rule_type
	Value = _value
	Default = _value
	emit_signal("data_init",self)
