extends Button

export var type = "buy"
export var commodity = "water"

var waterBuy = 20
var waterSell = 15
var oxygenBuy = 10
var oxygenSell = 7
var foodBuy = 100
var foodSell = 65
var mineralBuy = 1000
var mineralSell = 800

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_button_pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _button_pressed():
	var baseController = get_parent().get_parent().get_parent().get_node("baseController")
	if baseController != null:
		if type == "buy":
			if commodity == "water":
				baseController.submit_trade(0,1,0,0,-waterBuy)
				#baseController.water_budget += 1
				#baseController.credit_budget -= waterBuy
			elif commodity == "food":
				baseController.submit_trade(1,0,0,0,-foodBuy)
				#baseController.food_budget += 1
				#baseController.credit_budget -= foodBuy
			elif commodity == "oxygen":
				baseController.submit_trade(0,0,1,0,-oxygenBuy)
				#baseController.oxygen_budget += 1
				#baseController.credit_budget -= oxygenBuy
			elif commodity == "mineral":
				baseController.submit_trade(0,0,0,1,-mineralBuy)
				#baseController.mineral_budget += 1
				#baseController.credit_budget -= mineralBuy
		else: 
			if commodity == "water":
				baseController.submit_trade(0,-1,0,0,waterSell)
				#baseController.water_budget -= 1
				#baseController.credit_budget += waterSell
			elif commodity == "food":
				baseController.submit_trade(-1,0,0,0,foodSell)
				#baseController.food_budget -= 1
				#baseController.credit_budget += foodSell
			elif commodity == "oxygen":
				baseController.submit_trade(0,0,-1,0,oxygenSell)
				#baseController.oxygen_budget -= 1
				#baseController.credit_budget += oxygenSell
			elif commodity == "mineral":
				baseController.submit_trade(0,0,0,-1,mineralSell)
				#baseController.mineral_budget -= 1
				#baseController.credit_budget += mineralSell
	else:
		print("could not find base!")
