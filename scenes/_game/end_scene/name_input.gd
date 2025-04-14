extends CanvasLayer
signal pressed(_name : String)
@export var _text_input : TextEdit

func on_button_pressed()->void:
    if _text_input.text == null or _text_input.text.length() <1:
        _text_input.text = "anonym_" + str(randi_range(0,9999))
    pressed.emit(_text_input.text)