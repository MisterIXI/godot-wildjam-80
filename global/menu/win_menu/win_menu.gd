extends Control
class_name WinMenu

@export var confirm_button : Button
@export var untransition : Untransition

@export var text : RichTextLabel
@export var text_edit : TextEdit

var default_text : String = "Dear Gamer,
You have done what many couldn't. You have beaten our game in [color=red][shake rate=20.0 level=5 connected=1]#TIME#[/shake][/color], which is very impressive I might add.

And you took the time to collect [rainbow freq=1.0 sat=1 val=0.8 speed=-1.0]#TPCOUNT# out of 5 toilette papers[/rainbow]. So next time nature calls, I can head to the bathroom without a worry.

#LEADERBOARD#



Keep it up gamer."

var leaderboard_active_text : String ="Your feat will give you the [color=blue][wave amp=50.0 freq=5.0 connected=1]#PLACE# place[/wave][/color] in the online leaderboard. Mind telling us your name? The world should know who pulled this off!"
var leaderboard_inactve_text : String = "I am sure you'd be at the top of the leaderboard - if it was working right now! You're welcome to enter your name anyway, even if it doesn't do much right now."

func _ready() -> void:
  visibility_changed.connect(_on_visibility_changed)
  confirm_button.pressed.connect(_on_button_pressed)


func _on_visibility_changed():
  if visible:
    var _text : String = default_text
    _text = _text.replace("#TIME#", _format_time(Session.current_run_seconds))
    _text = _text.replace("#TPCOUNT#", _format_collectables(Session.collectables))

    if Schlüsseljunge.leaderboard_active:
      _text = _text.replace("#LEADERBOARD#", leaderboard_active_text)

      ReferenceManager.highscore_node.get_leaderboard()
      await ReferenceManager.highscore_node.leaderboard_request_completed
      var highscore_times = []
      for item in ReferenceManager.highscore_node.highscore_table:
        highscore_times.append(int(item.time))
      highscore_times.append(int(Session.current_run_seconds))
      highscore_times.sort()
      print("Highscore times:", highscore_times)
      var place : int = highscore_times.find(int(Session.current_run_seconds))
      _text = _text.replace("#PLACE#", _format_place(place+1))
    else:
      _text = _text.replace("#LEADERBOARD#", leaderboard_inactve_text)

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


func _on_button_pressed() -> void:
  if Schlüsseljunge.leaderboard_active == false:
    return
  var _name : String = text_edit.text.replace(" ", "_").split("\n")[0].strip_edges()
  if _name == "":
    _name = "Anonymous"

  var _col_count : int = 0
  for val in Session.collectables.values():
    if val:
      _col_count += 1

  ReferenceManager.highscore_node.set_new_highscore(_name, int(Session.current_run_seconds), _col_count, PlayerUidManager.get_playeruid())


func _input(event: InputEvent) -> void:
  if visible and event is InputEventKey and event.keycode == KEY_ENTER:
    text_edit.release_focus()