extends Node2D

export (PackedScene) var letter_obj

export var line_length = 100

export var text = ""

var width = 8
var height = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	force_update(text, null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Engine.is_editor_hint():
#		update_text(text,null)

func clear_text():
	for child in get_children():
		remove_child(child)
		child.queue_free()

func force_update(new_text, modulate):
	var x = 0
	var y = 0
	text = new_text
	clear_text()
	for letter in text:
		if letter != ' ':
			var new_letter = letter_obj.instance()
			new_letter.position.x = x
			new_letter.position.y = y
			if modulate != null:
				new_letter.modulate = modulate
			add_child(new_letter)
			assignLetter(new_letter, letter)
		x += width
		if x > line_length*width:
			x = 0
			y += height

func update_text(new_text, modulate):
	if new_text != text:
		force_update(new_text, modulate)

# kill me now
func assignLetter(obj, letter):
	if letter == 'A':
		obj.frame = 0
	elif letter == 'B':
		obj.frame = 1
	elif letter == 'C':
		obj.frame = 2
	elif letter == 'D':
		obj.frame = 3
	elif letter == 'E':
		obj.frame = 4
	elif letter == 'F':
		obj.frame = 5
	elif letter == 'G':
		obj.frame = 6
	elif letter == 'H':
		obj.frame = 7
	elif letter == 'I':
		obj.frame = 8
	elif letter == 'J':
		obj.frame = 9
	elif letter == 'K':
		obj.frame = 10
	elif letter == 'L':
		obj.frame = 11
	elif letter == 'M':
		obj.frame = 12
	elif letter == 'N':
		obj.frame = 13
	elif letter == 'O':
		obj.frame = 14
	elif letter == 'P':
		obj.frame = 15
	elif letter == 'Q':
		obj.frame = 16
	elif letter == 'R':
		obj.frame = 17
	elif letter == 'S':
		obj.frame = 18
	elif letter == 'T':
		obj.frame = 19
	elif letter == 'U':
		obj.frame = 20
	elif letter == 'V':
		obj.frame = 21
	elif letter == 'W':
		obj.frame = 22
	elif letter == 'X':
		obj.frame = 23
	elif letter == 'Y':
		obj.frame = 24
	elif letter == 'Z':
		obj.frame = 25
	elif letter == 'a':
		obj.frame = 26
	elif letter == 'b':
		obj.frame = 27
	elif letter == 'c':
		obj.frame = 28
	elif letter == 'd':
		obj.frame = 29
	elif letter == 'e':
		obj.frame = 30
	elif letter == 'f':
		obj.frame = 31
	elif letter == 'g':
		obj.frame = 32
	elif letter == 'h':
		obj.frame = 33
	elif letter == 'i':
		obj.frame = 34
	elif letter == 'j':
		obj.frame = 35
	elif letter == 'k':
		obj.frame = 36
	elif letter == 'l':
		obj.frame = 37
	elif letter == 'm':
		obj.frame = 38
	elif letter == 'n':
		obj.frame = 39
	elif letter == 'o':
		obj.frame = 40
	elif letter == 'p':
		obj.frame = 41
	elif letter == 'q':
		obj.frame = 42
	elif letter == 'r':
		obj.frame = 43
	elif letter == 's':
		obj.frame = 44
	elif letter == 't':
		obj.frame = 45
	elif letter == 'u':
		obj.frame = 46
	elif letter == 'v':
		obj.frame = 47
	elif letter == 'w':
		obj.frame = 48
	elif letter == 'x':
		obj.frame = 49
	elif letter == 'y':
		obj.frame = 50
	elif letter == 'z':
		obj.frame = 51
	elif letter == '1':
		obj.frame = 52
	elif letter == '2':
		obj.frame = 53
	elif letter == '3':
		obj.frame = 54
	elif letter == '4':
		obj.frame = 55
	elif letter == '5':
		obj.frame = 56
	elif letter == '6':
		obj.frame = 57
	elif letter == '7':
		obj.frame = 58
	elif letter == '8':
		obj.frame = 59
	elif letter == '9':
		obj.frame = 60
	elif letter == '0':
		obj.frame = 61
	elif letter == ',':
		obj.frame = 62
	elif letter == '.':
		obj.frame = 63
	elif letter == '!':
		obj.frame = 64
	elif letter == '?':
		obj.frame = 65
	elif letter == '$':
		obj.frame = 66
	elif letter == '-':
		obj.frame = 67
	elif letter == '*':
		obj.frame = 68
	elif letter == '\'':
		obj.frame = 69 # nice
	elif letter == '(':
		obj.frame = 70
	elif letter == ')':
		obj.frame = 70
		obj.scale.x = -obj.scale.x
	else:
		obj.frame = 65
