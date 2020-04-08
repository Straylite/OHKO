mrb = memory.readbyte
mwb = memory.writebyte

health = 0x02002AEA
local timer = 2*(60*60)
local timerswitch = false
local minutes = 1
local hN = mrb(0x02002AEA)
local shield = 1
local x = 0

kills = 0x02002A90
local killsN = memory.read_u32_le(0x02002A90)

while true do

local killsC = memory.read_u32_le(kills)

mwb(0x0200AF01, 0x10) -- Disable HeartDisplay

local hC = mrb(health)
if mrb(0x03001004) ~= 0x07 and mrb(0x03001002) == 0x2 then
if shield == 1 then
gui.drawBox(2,2,2+7200/100,10, "white" ,0xB003c4ff)
elseif shield == 0 then
gui.drawBox(2,2,2+7200/100,10, "white" ,0x5003c4ff)
gui.drawBox(2,2,3+(timer/100),10, 0x00000000 ,0xA0ff0303)
	if timer < 10*60 then
		gui.pixelText(62,3,string.format("%02d", timer/60))
	end
end
gui.drawBox(76,2,86,10, "white" ,0xB0f54242)
gui.pixelText(77,3,mrb(0x02002AEB)/8, "white", 0x00000000)
if shield == 1 then gui.pixelText(3,3, "Shield active", "white", 0x00000000) end
end

if mrb(0x03001002) == 0x3 then timer = 3600 end

if mrb(0x03000BF4) ~= 0x25 then

if timer < 1 then shield = 1 timerswitch = false timer = 7200 end

if timerswitch == true then timer = timer-1 end
if hC ~= hN then
	if hC < hN and shield == 1 then
		shield = 0
		timerswitch = true
	end
	if hC < hN and shield == 0 and timer < 7195 then 
		memory.writebyte(0x0300116C, 0xA)
	end
  hN = hC
  mwb(0x02002AEA, mrb(0x02002AEB))
end
end

if shield == 0 then
	if killsC ~= killsN then
		timer = timer - 300
		killsN = killsC
	end
end

emu.frameadvance()
end