extends Node

export (PackedScene) var baseBuilding

export (PackedScene) var tunnelScene

var food_budget = 1.0
var water_budget = 1.0
var oxygen_budget = 1.0
var mineral_budget = 0.0
var credit_budget = -100000000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().get_node("counts/food").update_text(format_num(food_budget))
	get_parent().get_parent().get_node("counts/water").update_text(format_num(water_budget))
	get_parent().get_parent().get_node("counts/oxygen").update_text(format_num(oxygen_budget))
	get_parent().get_parent().get_node("counts/minerals").update_text(format_num(mineral_budget))
	get_parent().get_parent().get_node("counts/credit").update_text(format_num(credit_budget))

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
	if dFood != 0:
		get_parent().get_parent().get_node("counts/food").update_text(format_num(food_budget))
	if dWater != 0:
		get_parent().get_parent().get_node("counts/water").update_text(format_num(water_budget))
	if dOxygen != 0:
		get_parent().get_parent().get_node("counts/oxygen").update_text(format_num(oxygen_budget))
	if dMinerals != 0:
		get_parent().get_parent().get_node("counts/minerals").update_text(format_num(mineral_budget))
	if dCredit != 0:
		get_parent().get_parent().get_node("counts/credit").update_text(format_num(credit_budget))
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drivers = get_drivers()
	if drivers == null:
		return
	var oldFood = food_budget
	var oldWater = water_budget
	var oldOxygen = oxygen_budget
	var oldMinerals = mineral_budget
	var oldCredits = credit_budget
	for driver in drivers:
		# just take all production for now
		food_budget += driver.food_store
		water_budget += driver.water_store
		oxygen_budget += driver.oxygen_store
		mineral_budget += driver.mineral_store
		food_budget += driver.food_store
	if oldFood != food_budget:
		get_parent().get_parent().get_node("counts/food").update_text(format_num(food_budget))
	if oldWater != water_budget:
		get_parent().get_parent().get_node("counts/water").update_text(format_num(water_budget))
	if oldOxygen != oxygen_budget:
		get_parent().get_parent().get_node("counts/oxygen").update_text(format_num(oxygen_budget))
	if oldMinerals != mineral_budget:
		get_parent().get_parent().get_node("counts/minerals").update_text(format_num(mineral_budget))
	if oldCredits != credit_budget:
		get_parent().get_parent().get_node("counts/credit").update_text(format_num(credit_budget))

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
