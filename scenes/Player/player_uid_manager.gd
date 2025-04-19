extends Node
class_name PlayerUID_Manager
var _player_uid : String = ""
var CHARACTERS : Array[String]  = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"]
const UID_SIZE : int  = 20

func set_playeruid(_string) ->void:
    _player_uid = _string
    print("PlayerUID = ",_player_uid)

func get_playeruid() -> String:
    return _player_uid

func create_playeruid() -> void:
    _player_uid = generate_uid()

func generate_uid() ->String:
    var _temp_uid : String = ""
    for x in UID_SIZE:
        var _temp_shuffle_array : Array[String]= CHARACTERS
        _temp_shuffle_array.shuffle()
        _temp_uid += _temp_shuffle_array[randi_range(0,_temp_shuffle_array.size())-1]
    var _uid :String = _temp_uid.sha256_text()
    if _uid:
        return _uid
    else:
        return generate_uid()
