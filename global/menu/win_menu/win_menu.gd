extends Control
class_name WinMenu

@export var confirm_button : Button
@export var untransition : Untransition

@export var text : RichTextLabel
@export var text_edit : TextEdit

var default_text : String = "Dear Gamer,
You have done what many couldn't. You have beaten our game in [color=red][shake rate=20.0 level=5 connected=1]#TIME#[/shake][/color], which is very impressive I might add.

And you took the time to collect [rainbow freq=1.0 sat=1 val=0.8 speed=-1.0]#TPCOUNT# out of 5 toilette papers[/rainbow]. So next time nature calls, I can head to the bathroom without a worry.

Your feat will give you the [color=blue][wave amp=50.0 freq=5.0 connected=1]#PLACE# place[/wave][/color] in the online leaderboard. Mind telling us your name? The world should know who pulled this off!



Keep it up gamer."

func _ready() -> void:
  visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
  if visible:
    var _text : String = default_text
    _text = _text.replace("#TIME#", _format_time(Session.current_run_seconds))
    _text = _text.replace("#TPCOUNT#", _format_collectables(Session.collectables))
    _text = _text.replace("#PLACE#", _format_place(5))
    #TODO: find current place
    text.text = _text



func _format_time(_time : float) -> String:
  var time : String = ReferenceManager.format(_time)
  var time_array = time.split(":")

  var time_string
  if time_array.size() == 3:
    time_string = time_array[0].replace("h", "  hours, ")
    time_string += time_array[1].replace("m", " minutes and ")
    time_string += time_array[2].replace("s", " seconds")
  else:
    time_string = " 0 hours, "
    time_string += time_array[0].replace("m", " minutes and ")
    time_string += time_array[1].replace("s", " seconds")
  
  return time_string


func _format_collectables(_collectables : Dictionary) -> String:
  var count = 0
  for val in _collectables.values():
    if val:
      count += 1
  return str(count)


func _format_place(_place : int) -> String:
  if _place == 1:
    return "#1st"
  elif _place == 2:
    return "#2nd"
  elif _place == 3:
    return "#3rd"
  else:
    return "#" + str(_place) + "th"