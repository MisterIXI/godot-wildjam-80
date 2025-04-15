extends Node

var path = "res://🔑"
var grace_key = "None"
var game_API_key = "None"
var leaderboard_key = "None"


func _ready():
  if not FileAccess.file_exists(path):
    print_rich("[color=Yellow]Schlüsseljunge >> [color=RED]Sorry sorry, ich habe den Schlüssel nicht gefunden, du kannst mal meinen boss danach fragen!")
    return
  
  var file = FileAccess.open(path, FileAccess.READ)
  grace_key = file.get_as_text().split("\n")[0].strip_edges()
  game_API_key = file.get_as_text().split("\n")[1].strip_edges()
  leaderboard_key = file.get_as_text().split("\n")[2].strip_edges()
  print_rich("[color=Yellow]Schlüsseljunge >> [color=WHITE]Yippeeee ich habe den Schlüssel gefunden!")
  file.close()