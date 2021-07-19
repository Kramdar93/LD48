extends Button

export var type = "buy"
export var commodity = "water"

var waterBuy = 750
var waterSell = 550
var oxygenBuy = 500
var oxygenSell = 400
var foodBuy = 1000
var foodSell = 650
var mineralBuy = 2500
var mineralSell = 2000

var delay = 0.5
var rate = 0.05

var timer = delay

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", self, "_button_pressed")

func handle_input():
	var baseController = get_parent().get_parent().get_parent().get_node("baseController")
	if baseController != null:
		var result = false
		if type == "buy":
			if commodity == "water":
				result = baseController.submit_trade(0,1,0,0,-waterBuy)
				#baseController.water_budget += 1
				#baseController.credit_budget -= waterBuy
			elif commodity == "food":
				result = baseController.submit_trade(1,0,0,0,-foodBuy)
				#baseController.food_budget += 1
				#baseController.credit_budget -= foodBuy
			elif commodity == "oxygen":
				result = baseController.submit_trade(0,0,1,0,-oxygenBuy)
				#baseController.oxygen_budget += 1
				#baseController.credit_budget -= oxygenBuy
			elif commodity == "mineral":
				result = baseController.submit_trade(0,0,0,1,-mineralBuy)
				#baseController.mineral_budget += 1
				#baseController.credit_budget -= mineralBuy
		else: 
			if commodity == "water":
				result = baseController.submit_trade(0,-1,0,0,waterSell)
				#baseController.water_budget -= 1
				#baseController.credit_budget += waterSell
			elif commodity == "food":
				result = baseController.submit_trade(-1,0,0,0,foodSell)
				#baseController.food_budget -= 1
				#baseController.credit_budget += foodSell
			elif commodity == "oxygen":
				result = baseController.submit_trade(0,0,-1,0,oxygenSell)
				#baseController.oxygen_budget -= 1
				#baseController.credit_budget += oxygenSell
			elif commodity == "mineral":
				result = baseController.submit_trade(0,0,0,-1,mineralSell)
				#baseController.mineral_budget -= 1
				#baseController.credit_budget += mineralSell
		if result:
			get_node("/root/Game/Static/audio").play_sfx("get")
		else:
			get_node("/root/Game/Static/audio").play_sfx("cancel")
	else:
		print("could not find base!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressed and timer <= 0:
		handle_input()
		timer = rate
	elif not pressed:
		timer = delay
	elif pressed and timer > 0:
		timer -= delta



func _button_pressed():
	handle_input()
