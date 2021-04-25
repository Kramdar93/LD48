extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action("ui_right"):
		position.x -= 12
	if event.is_action("ui_left"):
		position.x += 12
	if event.is_action("ui_up"):
		if position.y + 12 <= 0:
			position.y += 12
		else:
			position.y = 0
	if event.is_action("ui_down"):
		position.y -= 12
	if event.is_action("ui_page_up"):
		if position.y + 120 <= 0:
			position.y += 120
		else:
			position.y = 0
	if event.is_action("ui_page_down"):
		position.y -= 120
	var depth_counter = get_node_or_null("counts/depth")
	if depth_counter != null:
		depth_counter.update_text(str(int(-position.y / 600)+1) + " Km", null)
