-- let's define the pins
-- Map the GPIO pin number to a MQTT topic
map = {}
map[1] = "Front Door"
map[2] = "Back Door"
map[3] = "Garage Entry"

-- MQTT config
topic_prefix = "pat/alarm/"
status_topic = "status"

-- Map MQTT payloads
payload = {}
payload[0] = "closed"
payload[1] = "open"
