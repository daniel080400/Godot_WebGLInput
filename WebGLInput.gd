extends Node

################ REMINDER ################
# Currently only supports "LineEdit" Class
#
#

class_name WebGLInput

## The control object ( to mimic Control class behavior in this script)
var control : Control

## The current focused UI
var current_focused_ui : Control


func _ready():
	# Don't do anything if not on WebGL platform
	if not OS.has_feature('JavaScript'):
		return
		
	# Construct Control object 
	control = Control.new()
	add_child(control)
	
	# Construct HTML input field
	construct_input_field(Vector2(1,1),1,1)
	
	
	# Hide HTML input field
	hide_input_field()


func _process(_delta):
	# Don't do anything if not on WebGL platform
	if not OS.has_feature('JavaScript'):
		return
	
	# If just changed focus to a new ui element
	if control.get_focus_owner() != current_focused_ui:
		current_focused_ui = control.get_focus_owner()
		_on_ui_changed_focus(current_focused_ui)
		
		
	# If "ENTER" key is pressed on HTML (Submit)
	if JavaScript.eval("submitted"):
		# Switch off the "submitted" flag
		JavaScript.eval("submitted = false;")
		
		# release focus from current focused ui
		current_focused_ui.release_focus()
		
		# Submit as LineEdit
		if current_focused_ui is LineEdit:
			var line_edit = current_focused_ui as LineEdit
			submit_as_line_edit(line_edit)
		
		# clear current focused ui
		current_focused_ui = null
		
	# If focused on LineEdit
	if current_focused_ui is LineEdit:
		var line_edit = current_focused_ui as LineEdit
		update_as_line_edit(line_edit)
		return
	
	# Hide the input field if nothing in interest is focused
	hide_input_field()
	

func _on_ui_changed_focus(_new_ui):
	# If new focus ui is LineEdit
	if _new_ui is LineEdit:
		# Get the text value out of LineEdit and apply to HTML input text
		var line_edit = _new_ui as LineEdit
		JavaScript.eval('input.value="' + line_edit.text + '";')


func update_as_line_edit(line_edit):
	# Get LineEdit's position, width and height
	var position = line_edit.rect_global_position
	var width = line_edit.rect_size.x
	var height = line_edit.rect_size.y
	
	update_input_field(position, width, height)
	
	# Grab the text entered and set it back to the focused LineEdit
	var text : String = JavaScript.eval('input.value')
	if (line_edit.text != text):
		line_edit.text = text
	
	return



func submit_as_line_edit(line_edit : LineEdit):
	line_edit.emit_signal("text_entered", line_edit.text)
	
	return



func construct_input_field(_position : Vector2, _width : float, _height : float) :
	
	# Create a input element in HTML
	JavaScript.eval('var input = document.createElement("input");', true)
	
	# Set a "justSubmitted" variable to detect when enter is pressed
	JavaScript.eval("var submitted = false;", true)
	
	
	# Set input's position, width and height
	JavaScript.eval('input.style.position = "absolute"; ')
	JavaScript.eval('input.style.top = "' + str(_position.y) + 'px";' )
	JavaScript.eval('input.style.left = "' + str(_position.x) + 'px";' )
	JavaScript.eval('input.style.width = "' + str(_width) + 'px";' )
	JavaScript.eval('input.style.height = "' + str(_height) + 'px";' )
	
	# Set the input element to transparent background
	JavaScript.eval('input.style.border = "none"; ')
	JavaScript.eval('input.style.background = "transparent"; ')
	JavaScript.eval('input.style.color = "transparent"; ')
	
	
	# Create a event when "ENTER" is pressed
	JavaScript.eval("""
		input.addEventListener("keydown", function(event){
			if (event.keyCode === 13 ){
				submitted = true;
			}
		})
		""")
	
	# Add the input field into HTML page
	JavaScript.eval('document.body.appendChild(input);')
	
	
	return



func update_input_field(_position : Vector2, _width : float, _height : float):
	# Set input field visible
	JavaScript.eval('input.style.display = "block"; ')
	
	# Focus on input field
	JavaScript.eval('input.focus(); ')
	
	# Update the input box's transform
	JavaScript.eval('input.style.top = "' + str(_position.y) + 'px";' )
	JavaScript.eval('input.style.left = "' + str(_position.x) + 'px";' )
	JavaScript.eval('input.style.width = "' + str(_width) + 'px";' )
	JavaScript.eval('input.style.height = "' + str(_height) + 'px";' )
	
	return


func hide_input_field():
	# Hide the html input field
	JavaScript.eval('if(input != null) { input.style.display = "none" }')
	
	# Clear the html input value
	JavaScript.eval('if(input != null) { input.value = "" } ')
	
	# Remove focus from HTMl input
	JavaScript.eval('input.blur();')
	
	return



