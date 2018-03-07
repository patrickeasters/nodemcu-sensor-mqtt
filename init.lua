--load credentials
dofile("secrets.lua")

function startup()
  if file.open("init.lua") == nil then
    print("init.lua deleted")
  else
    print("Running")
    file.close("init.lua")
    dofile("sensor.lua")
  end
end

--init.lua
print("Setting up wifi")
wifi.setmode(wifi.STATION)
wifi.sta.config(WIFI_CONFIG)
wifi.sta.connect()
wifi.sta.autoconnect(1)
tmr.alarm(1, 1000, 1, function()
    if wifi.sta.getip()== nil then
      print("Waiting on dhcp...")
    else
      tmr.stop(1)
      print("Config done, IP is "..wifi.sta.getip())
      print("You have 5 seconds to abort startup")
      print("Waiting...")
      tmr.alarm(0, 5000, 0, startup)
    end
 end)
