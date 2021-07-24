extends Node2D

var type = "none"

var sensing_tick_delay = 0.1
var sensing_tick_timer = 0

var speed = 2.5

var target = null

var alive = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	if not alive: return
	sensing_tick_timer += delta
	if sensing_tick_timer > sensing_tick_delay:
		sensing_tick_timer = 0
		# find buildings that can be attacked right now
		var overlaps = get_node("attackArea").get_overlapping_areas()
		for area in overlaps:
			var building = area.get_parent()
			if building != null and building.has_method("extract_init") and building.is_active:
				handle_attack(building)
		# clear target if it dies
		if target != null and not target.is_active:
			target = null
		# find new target
		var mindist
		if target == null:
			mindist = 1000
		else:
			mindist = target.global_position.distance_to(global_position)
		overlaps = get_node("sensingArea").get_overlapping_areas()
		for area in overlaps:
			var building = area.get_parent()
			if building != null and building.has_method("extract_init") and building.is_active and building.type != "port":
				var newdist = building.global_position.distance_to(global_position)
				if newdist < mindist:
					mindist = newdist
					target = building
		if target != null:
			var move = (target.global_position - global_position).normalized() * speed
			global_position += move

func handle_attack(building):
	if(building.type == "fortification"):
		alive = false
		find_node("Sprite").modulate = Color(1,0,0)
	else:
		building.kill()
	target = null
	

func get_type():
	return type
