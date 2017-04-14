-- BEGIN CONFIGURATION
dofile("config.lua")

-- END CONFIGURATION
state = {}
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
  for p,v in pairs(map) do
    s = gpio.read(p)
    --print("Pin "..p.." is "..s.." with state "..state[p])
    if s ~= state[p] then
      print("Pin "..p.." has changed to "..s)
      state[p] = s
      if connected == 1 then
        m:publish(topic_prefix..map[p], payload[s], 0, 1)
      end
    end
  end
end


-- init mqtt client and connect
m = mqtt.Client(MQTT_CLIENT_ID, 120, MQTT_USER, MQTT_PASS)

m:on("offline", function(client)
    print ("mqtt offline")
    connected = 0
  end)

-- connect to mqtt with creds and autoreconnect
m:connect(MQTT_HOST, MQTT_PORT, 0, 1, function(client)
    print("mqtt connected")
    m:publish(topic_prefix..status_topic, "online", 0, 0)
    connected = 1
  end,
  function(client, reason) print("failed reason: "..reason) end)

-- setup lwt topic
m:lwt(topic_prefix..status_topic, "offline", 0, 0)

-- now map gpio stuff
for p,v in pairs(map) do
  gpio.mode(p, gpio.INT, gpio.PULLUP)
  gpio.trig(p, 'both', debounce(onChange) )
  state[p] = nil
  print("Mapping pin "..p.." as "..v)
end
