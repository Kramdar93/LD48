extends Node

export (PackedScene) var baseBuilding

export (PackedScene) var tunnelScene

var food_budget = 1.0
var water_budget = 1.0
var oxygen_budget = 1.0
var mineral_budget = 0.0
var credit_budget = -10000.0

var oldFood = food_budget
var oldWater = water_budget
var oldOxygen = oxygen_budget
var oldMinerals = mineral_budget
var oldCredits = credit_budget

const in_the_red = Color(1.0,0.0,0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_food(true)
	update_water(true)
	update_oxygen(true)
	update_minerals(true)
	update_credits(true)
	if get_drivers() == null:
		print("no building drivers!")

func format_num(n):
	var result = ""
	var unformatted = str(int(n))
	var array = []
	for digit in unformatted: # can only traverse like this forwards...
		array.append(digit)
	for i in range(len(array)):
		var rev_i = len(array) - 1 - i
		if i > 0 and i % 3 == 0 and array[rev_i].is_valid_integer():
			result = ',' + result
		result = array[rev_i] + result
	return result

func update_food(force):
	var mod = null
	if food_budget <= 0:
		mod = in_the_red
		get_node("/root/Game/Static/Clock").showCountdown("food")
	else:
		get_node("/root/Game/Static/Clock").clearTimer("food")
	if force:
		get_parent().get_parent().get_node("counts/food").force_update(format_num(food_budget),mod)
	else:
		get_parent().get_parent().get_node("counts/food").update_text(format_num(food_budget),mod)
	
func update_water(force):
	var mod = null
	if water_budget <= 0:
		mod = in_the_red
		get_node("/root/Game/Static/Clock").showCountdown("water")
	else:
		get_node("/root/Game/Static/Clock").clearTimer("water")
	if force:
		get_parent().get_parent().get_node("counts/water").force_update(format_num(water_budget),mod)
	else:
		get_parent().get_parent().get_node("counts/water").update_text(format_num(water_budget),mod)
	
func update_oxygen(force):
	var mod = null
	if oxygen_budget <= 0:
		mod = in_the_red
		get_node("/root/Game/Static/Clock").showCountdown("oxygen")
	else:
		get_node("/root/Game/Static/Clock").clearTimer("oxygen")
	if force:
		get_parent().get_parent().get_node("counts/oxygen").force_update(format_num(oxygen_budget),mod)
	else:
		get_parent().get_parent().get_node("counts/oxygen").update_text(format_num(oxygen_budget),mod)
	
func update_minerals(force):
	if force:
		get_parent().get_parent().get_node("counts/minerals").force_update(format_num(mineral_budget),null)
	else:
		get_parent().get_parent().get_node("counts/minerals").update_text(format_num(mineral_budget),null)
	
func update_credits(force):
	var mod = null
	if credit_budget <= 0:
		mod = in_the_red
	if force:
		get_parent().get_parent().get_node("counts/credit").force_update(format_num(credit_budget),mod)
	else:
		get_parent().get_parent().get_node("counts/credit").update_text(format_num(credit_budget),mod)
	

func submit_trade(dFood,dWater,dOxygen,dMinerals,dCredit):
	if food_budget + dFood < 0:
		return false
	if water_budget + dWater < 0:
		return false
	if oxygen_budget + dOxygen < 0:
		return false
	if mineral_budget + dMinerals < 0:
		return false
	food_budget += dFood
	water_budget += dWater
	oxygen_budget += dOxygen
	mineral_budget += dMinerals
	credit_budget += dCredit
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drivers = get_drivers()
	if drivers != null:
		for driver in drivers:
			# just take all production for now
			food_budget += driver.food_store
			water_budget += driver.water_store
			oxygen_budget += driver.oxygen_store
			mineral_budget += driver.mineral_store
			food_budget += driver.food_store
	if oldFood != food_budget:
		update_food(false)
	if oldWater != water_budget:
		update_water(false)
	if oldOxygen != oxygen_budget:
		update_oxygen(false)
	if oldMinerals != mineral_budget:
		update_minerals(false)
	if oldCredits != credit_budget:
		update_credits(false)
	oldFood = food_budget
	oldWater = water_budget
	oldOxygen = oxygen_budget
	oldMinerals = mineral_budget
	oldCredits = credit_budget

func get_drivers():
	var drivers = []
	for child in get_children():
		var child_driver = child.get_node("driver")
		if child_driver != null:
			drivers.append(child_driver)

func create_building(originBuilding, position):
	var newBuilding = baseBuilding.instance()
	get_parent().add_child(newBuilding)
	newBuilding.global_position = position
	var o_driver = originBuilding.get_node("driver")
	var n_driver = newBuilding.get_node("driver")
	o_driver.child_buildings.append(newBuilding)
	n_driver.parent_building = originBuilding
	var tunnel = tunnelScene.instance()
	get_parent().add_child(tunnel)
	tunnel.global_position = Vector2.ZERO
	tunnel.points[0] = originBuilding.global_position
	tunnel.points[1] = newBuilding.global_position
