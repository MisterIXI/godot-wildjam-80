extends CanvasLayer
signal pressed(_name : String)
@export var _text_input : LineEdit

func _on_textedit_submitted(value : String) ->void:
    var _new_text : String = value
    if _new_text == null or _new_text.length() <1:
        _new_text = "anonym_" + str(randi_range(0,9999))
        _text_input.text = _new_text
    pressed.emit(_new_text)
    await get_tree().create_timer(0.5, false, true).timeout
    queue_free()


func on_button_pressed()->void:
    if _text_input.text == null or _text_input.text.length() <1:
        _text_input.text = "anonym_" + str(randi_range(0,9999))
    pressed.emit(_text_input.text)
    await get_tree().create_timer(0.5, false, true).timeout
    queue_free()