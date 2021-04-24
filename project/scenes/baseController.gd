extends Node

export (PackedScene) var baseBuilding

var food_budget = 1.0
var water_budget = 1.0
var oxygen_budget = 1.0
var mineral_budget = 0.0
var credit_budget = -1000000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drivers = get_drivers()
	if drivers == null:
		return
	for driver in drivers:
		# just take all production for now
		food_budget += driver.food_store
		water_budget += driver.water_store
		oxygen_budget += driver.oxygen_store
		mineral_budget += driver.mineral_store
		food_budget += driver.food_store

func get_drivers():
	var drivers = []
	for child in get_children():
		var child_driver = child.get_node("driver")
		if child_driver != null:
			drivers.append(child_driver)

func create_building(originBuilding, position):
	var newBuilding = baseBuilding.instance()
	get_parent().add_child(newBuilding)
	newBuilding.position = position
	var o_driver = originBuilding.get_node("driver")
	var n_driver = newBuilding.get_node("driver")
	o_driver.child_buildings.append(newBuilding)
	n_driver.parent_building = originBuilding
