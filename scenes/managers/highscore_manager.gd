extends Node
class_name Highscore_Manager
signal leaderboard_request_completed

const URIGET  = "_get"
const STR  ="/"

var highscore_table : Array[Highscore_Entry]
var send_request : HTTPRequest
var leaderboard_request : HTTPRequest
var headers = ["Content-Type: application/x-www-form-urlencoded"]

func _ready() -> void:
	highscore_table.clear()
	ReferenceManager.highscore_node = self
	get_leaderboard()

############## GLOBAL SET HIGHSCORE FUNCTION ##############
func set_new_highscore(_name, _score : int, _collectables : int, _playeruid : String) -> void:
	if Schlüsseljunge.leaderboard_key == "None" or Schlüsseljunge.game_API_key == "None":
		return

	# IF DEBUG_MODE  = FALSE
	#print("Debug Highscore: New Highscore %s&- %s&- %s" % [_name,_score, _collectables])
	# highscore_table.append(Highscore_Entry.new(_name,str(_score),str(_collectables), Time.get_datetime_string_from_system(),_playeruid))
	_send_score(_name,_score,_collectables,_playeruid)

#######################################################################################
func _on_score_request_completed(_result, _response_code, _header, _body) -> void:
	print("send completed")
	# var json = JSON.new()
	# json.parse(_body.get_string_from_utf8())
	
	# Print data
	print(_body.get_string_from_ascii())
	# clear node
	send_request.queue_free()

func _on_leaderboard_request_completed(_result, _response_code, _headers, body) ->void:
	print("get_leaderboard_completed")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	# IN 20 YEARS, THERE IS NO INTERNET

	if json.get_data():
		Schlüsseljunge.leaderboard_active = true
	else:
		Schlüsseljunge.leaderboard_active = false
		leaderboard_request_completed.emit()
		return
	print(json.get_data())
	highscore_table.clear()
	for x in json.get_data():
		highscore_table.append(Highscore_Entry.new(x["player_name"],x["score"],x["collectables"], x["timestamp"],x["playeruid"]))
	print("Leaderboard_Manager : highscores loaded")
	leaderboard_request.queue_free()
	leaderboard_request_completed.emit()

func _send_score(_name: String, _score :int, _collectables : int, _playeruid : String):
	if Schlüsseljunge.leaderboard_key == "None" or Schlüsseljunge.game_API_key == "None":
		return

	var _signature  =  (_name + str(_score) +str(_collectables) + _playeruid + Schlüsseljunge.game_API_key).sha256_text()
	print(_signature)
	var form_data = "name=%s&score=%s&timestamp=%s&collectables=%s&playeruid=%s&signature=%s" % [
        _name.uri_encode(), str(_score),Time.get_datetime_string_from_system(), str(_collectables), _playeruid, _signature.uri_encode()
    ]
	send_request = HTTPRequest.new()
	add_child(send_request)
	send_request.request_completed.connect(_on_score_request_completed)
	# Send request
	#print(form_data)
	send_request.request(Schlüsseljunge.leaderboard_key +STR, headers, HTTPClient.METHOD_POST, form_data)

func get_leaderboard() -> void :
	if Schlüsseljunge.leaderboard_key == "None" or Schlüsseljunge.game_API_key == "None":
		return

	leaderboard_request = HTTPRequest.new()
	add_child(leaderboard_request)
	leaderboard_request.request_completed.connect(_on_leaderboard_request_completed)# maybe later
	leaderboard_request.request(Schlüsseljunge.leaderboard_key+URIGET + STR)
