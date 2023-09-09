extends Control
class_name RuleGuiItem

# Тип правила
#var _type = null

@onready var _node_image = get_node("CenterContainer/HBoxContainer/img")
@onready var _node_value = get_node("CenterContainer/HBoxContainer/value")

func _ready():
	self.visible = false
#------------------------------------------------
# Устанавливаем цвет и изображение для правила
func set_type(rule_type,default_value):
	if rule_type == Globals.RULE_TYPE.NONE:
		self.visible = false	
		return
		
	_node_image.texture = Globals.RULE_TYPE_IMG[rule_type]
	# перекрашиваем под цвет
	match rule_type:
		Globals.RULE_TYPE.BALL1: _set_color(1)
		Globals.RULE_TYPE.BALL2: _set_color(2)
		Globals.RULE_TYPE.BALL3: _set_color(3)
	
	#_default = default_value
	set_value(default_value)
	self.visible = true	
	pass
#------------------------------------------------
# Изменение цвета окраски для шариковы
func _set_color(color:int)->void:
	_node_image.set_modulate(Globals.Ball_ColorMap[color])
	pass	
#------------------------------------------------	
func set_value(new_value:int):
	#_value = new_value 
	_node_value.text = "%s" % new_value
#------------------------------------------------
# Проверка правил
#------------------------------------------------
func update_item(item:RuleItem):
	"""		
		match item.Type:
		"": 
			visible = false
		"moves": 
			print("update_item moves")#;make_step()
		"ball1": 
			print("update_item ball1")
			set_type(Globals.RULE_TYPE.BALL1,item.Value)
		"ball2": 
			print("update_item ball2")
			set_type(Globals.RULE_TYPE.BALL2,item.Value)	
		"ball3": 
			print("update_item ball3")
			set_type(Globals.RULE_TYPE.BALL3,item.Value)	
	"""
	set_type(item.Type,item.Value)
	pass
