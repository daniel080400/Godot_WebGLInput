# Godot_WebGLInput
Implement IME into Godot's HTML export

![image](https://user-images.githubusercontent.com/26960237/210824397-3cd5ee41-8849-4747-ba3d-865ae1f3ab8c.png)

Compatable with Godot 3.5.1

Features:
1. Implement IME input for Godot HTML export
2. Enter will trigger the "text_entered(new_text : String)" signal


How to use:
1. Download the "WebGLInput.gd" file
2. Attach that script to anywhere in scene
3. Done, now add some LineEdit into scene, and test it in a html export


Limitations:
1. Currently the caret is not displayed
2. Only works on LineEdit class object
