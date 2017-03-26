-- BEGIN CONFIGURATION

-- let's define the pins
-- Map the GPIO pin number to a MQTT topic
map = {}
state = {}
map[1] = "Front Door"
map[2] = "Back Door"
map[3] = "Garage Entry"

-- MQTT topic prefix
topic_prefix = "pat/alarm/"

-- END CONFIGURATION

connected = 0

-- shamelessly adapted from github https://gist.github.com/marcelstoer/59563e791effa4acb65f
function debounce (func)
    local last = 0
    local delay = 50000 -- 50ms * 1000 as tmr.now() has μs resolution

    return function (...)
        local now = tmr.now()
        local delta = now - last
        if delta < 0 then delta = delta + 2147483647 end; -- proposed because of delta rolling over, https://github.com/hackhitchin/esp8266-co-uk/issues/2
        if delta < delay then return end;

        last = now
        return func(...)
    end
end


function onChange ()
  print("onChange triggered")
  for p,v in ipairs(map) do
    s = gpio.read(p)
    --print("Pin "..p.." is "..s.." with state "..state[p])
    if s ~= state[p] then
      print("Pin "..p.." has changed to "..s)
      state[p] = s
      if connected == 1 then
        m:publish(topic_prefix..map[p], s, 0, 1)
      end
    end
  end
end


-- init mqtt client and connect
m = mqtt.Client("node1", 120, MQTT_USER, MQTT_PASS)

m:on("offline", function(client)
    print ("mqtt offline")
    connected = 0
  end)

-- connect with creds
m:connect(MQTT_HOST, MQTT_PORT, 0, function(client)
    print("mqtt connected")
    connected = 1
  end,
  function(client, reason) print("failed reason: "..reason) end)

-- now map gpio stuff
for p,v in ipairs(map) do
  gpio.mode(p, gpio.INT, gpio.PULLUP)
  gpio.trig(p, 'both', debounce(onChange) )
  state[p] = nil
  print("Mapping pin "..p.." as "..v)
end
