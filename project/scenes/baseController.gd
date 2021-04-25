extends Node

export (PackedScene) var baseBuilding

export (PackedScene) var tunnelScene

var food_budget = 1.0
var water_budget = 1.0
var oxygen_budget = 1.0
var mineral_budget = 1.0
var credit_budget = -100000.0

var oldFood = food_budget
var oldWater = water_budget
var oldOxygen = oxygen_budget
var oldMinerals = mineral_budget
var oldCredits = credit_budget

var total_earned_credits = 0
var total_spent_credits = 0

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
	get_node("/root/Game/Static/Clock").registerBase(get_node("."))

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
	var mod = null
	if mineral_budget <= 0:
		mod = in_the_red
	if force:
		get_parent().get_parent().get_node("counts/minerals").force_update(format_num(mineral_budget),mod)
	else:
		get_parent().get_parent().get_node("counts/minerals").update_text(format_num(mineral_budget),mod)
	
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
	if dCredit > 0:
		total_earned_credits += dCredit
	elif dCredit < 0:
		total_spent_credits -= dCredit
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drivers = get_drivers()
	for driver in drivers:
		# just take all production for now
		food_budget += driver.food_store
		water_budget += driver.water_store
		oxygen_budget += driver.oxygen_store
		mineral_budget += driver.mineral_store
		credit_budget += driver.credit_store
		# one time use
		driver.food_store = 0.0
		driver.water_store = 0.0
		driver.oxygen_store = 0.0
		driver.mineral_store = 0.0
		driver.credit_store = 0.0
	if oldFood != food_budget:
		update_food(false)
		print("food: " + str(food_budget) + " (" + str(food_budget - oldFood) + ")")
	if oldWater != water_budget:
		update_water(false)
		print("water: " + str(water_budget) + " (" + str(water_budget - oldWater) + ")")
	if oldOxygen != oxygen_budget:
		update_oxygen(false)
		print("oxygen: " + str(oxygen_budget) + " (" + str(oxygen_budget - oldOxygen) + ")")
	if oldMinerals != mineral_budget:
		update_minerals(false)
		print("minerals: " + str(mineral_budget) + " (" + str(mineral_budget - oldMinerals) + ")")
	if oldCredits != credit_budget:
		update_credits(false)
		print("credits: " + str(credit_budget) + " (" + str(credit_budget - oldCredits) + ")")
		if credit_budget >= 0:
			pack_stats()
			get_tree().change_scene("res://scenes/infoscreens/winner.tscn")
	oldFood = food_budget
	oldWater = water_budget
	oldOxygen = oxygen_budget
	oldMinerals = mineral_budget
	oldCredits = credit_budget

func get_drivers():
	var drivers = []
	for child in get_parent().get_children():
		var child_driver = child.get_node_or_null("driver")
		if child_driver != null:
			drivers.append(child_driver)
	return drivers

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

func pack_stats():
	var statholder = get_node_or_null("/root/Stats")
	if statholder != null:
		statholder.real_time = get_node("/root/Game/Static/Clock").total_time
		statholder.seconds_in_day = get_node("/root/Game/Static/Clock").seconds_in_day
		statholder.credits_spent = total_spent_credits
		statholder.credits_earned = total_earned_credits
		for sibling in get_parent().get_children():
			if sibling is Node2D or sibling is Line2D:
				# sanitize building
				var build_menu = sibling.get_node_or_null("build_menu")
				if build_menu != null:
					build_menu.remove()
				var button = sibling.get_node_or_null("Button")
				if button != null:
					sibling.remove_child(button)
					button.queue_free()
				var driver = sibling.get_node_or_null("driver")
				if driver != null:
					sibling.remove_child(driver)
					driver.queue_free()
				if "sticky_y" in sibling and sibling.sticky_y:
					sibling.sticky_y = false
					sibling.position.y = sibling.old_y
				sibling.get_parent().remove_child(sibling)
				statholder.add_child(sibling)
	
