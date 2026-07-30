extends Node

# Universal Plug and Play Implementation

var upnp: UPNP

func _ready() -> void:
	upnp = UPNP.new()
	var discover_result = upnp.discover()
	
	print("Discover result:", discover_result)
	print("Device count:", upnp.get_device_count())

	for i in range(upnp.get_device_count()):
		print(upnp.get_device(i))

	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		var gateway = upnp.get_gateway()
		if gateway == null:
			print("Gateway not found!")
			return
		if not upnp.get_gateway().is_valid_gateway():
			print("Gateway not valid!")
			return
		
		var map_result_udp = upnp.add_port_mapping(9999, 9999, "godot_udp", "UDP", 0)
		if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
			map_result_udp = upnp.add_port_mapping(9999, 9999, "", "UDP")
		print("Port Mapping Result: ", map_result_udp)
	var external_ip = upnp.query_external_address()
	
	print("External IP: ", external_ip)

func close_port():	
	upnp.delete_port_mapping(9999, "UDP")
