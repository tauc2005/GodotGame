extends Node
@export var Rules={
	# экран 1
	1:{		
		"ball1":{
			"current":0,	#текущее кол-во шариков на экране
			"min":0,		# мин  кол-во шариков на экране
			"max":0, 		# макс кол-во шариков на экране
			"limit":2,		# число за игру 
			"limited":1		# кол-во граничено
			},
		"ball2":{
			"min":0,
			"max":0,
			"limit":3,
			"limited":1
			},
		"ball3":{
			"min":0,
			"max":0,
			"limit":5,
			"limited":1
			},
		"ball4":{
			"min":0,
			"max":0,
			"limit":0,
			"limited":0
			},
		"stone":{
			"min":0,
			"max":0,
			"limit":0,
			"limited":1
			},
		"ice":{
			"min":0,
			"max":0,
			"limit":0,
			"limited":1
			},	
		}
	}
