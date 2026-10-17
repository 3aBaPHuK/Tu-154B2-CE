-- -- this is rain logic

-- -- dataRefs
-- wiper_angle_left = globalPropertyf("tu154b2/custom/anim/wiper_angle_left")
-- wiper_angle_right = globalPropertyf("tu154b2/custom/anim/wiper_angle_right")
rain_fr = globalPropertyf("sim/private/controls/rain/friction_static")
rain_sc = globalPropertyf("sim/private/controls/rain/scale")
tas = globalPropertyf("sim/flightmodel/position/true_airspeed")
rain_spawn = globalPropertyf("sim/private/controls/rain/spawn_adjust")
rain_fric_dyn = globalPropertyf("sim/private/controls/rain/friction_dynamic")
wip_left = globalPropertyf("tu154b2/custom/anim/wiper_side_1")
wip_right = globalPropertyf("tu154b2/custom/anim/wiper_side_2")
frame_time = globalPropertyf("tu154b2/custom/time/frame_time")
win_L = globalPropertyf("tu154b2/custom/anim/cockpit_window_left")
win_R = globalPropertyf("tu154b2/custom/anim/cockpit_window_right")
-- defineProperty("db1", globalPropertyf("tu154b2/custom/controlls/debug1"))
-- defineProperty("db2", globalPropertyf("tu154b2/custom/controlls/debug2"))

-- -- Smart Copilot
ismaster = globalPropertyf("scp/api/ismaster") -- Master. 0 = plugin not found, 1 = slave 2 = master
local fr_tbl= {{-300, 0.9 }, 
			{  0, 0.9}, 
			{  50,0.7},
		  {  100000, 0.7 }} 
		  
local sc_tbl= {{-300, 1 }, 
			{  0, 1}, 
			{  70,0.2},
		  {  100000, 0.2 }} 
local wip_L = 0
local wip_Lim_L = 0
local wip_R = 0
local wip_Lim_R = 0
local open_L = 0
local open_R = 0
function update()
	local skor=get(tas)
	local friction=0.9--interpolate(fr_tbl,skor)
	local scale=interpolate(sc_tbl,skor)
	local passed = get(frame_time)
	
	local MASTER = get(ismaster) ~= 1	
		

	if MASTER then	
		set(rain_fr,friction)
		set(rain_sc,scale)
		set(rain_fric_dyn,0)
		set(rain_spawn,2)
	end	
	-- fake wipers for sliding windows
	if open_L == 0 and get(win_L) > 0.7 then
		open_L = 1
	elseif open_L == 1 and get(win_L) < 0.3 then
		open_L = 0
	end
	if open_L == 0 then
		wip_L = 0
		wip_Lim_L = 0
	else
		if wip_Lim_L < 1 then
			wip_Lim_L = wip_Lim_L + passed / 20
		end
		if wip_L == 0 then
			wip_L = wip_Lim_L
		else
			wip_L = 0
		end
	end
	
	if open_R == 0 and get(win_R) > 0.7 then
		open_R = 1
	elseif open_R == 1 and get(win_R) < 0.3 then
		open_R = 0
	end
	if open_R == 0 then
		wip_R = 0
		wip_Lim_R = 0
	else
		if wip_Lim_R < 1 then
			wip_Lim_R = wip_Lim_R + passed / 20
		end
		if wip_R == 0 then
			wip_R = wip_Lim_R
		else
			wip_R = 0
		end
	end
	
	set(wip_left,wip_L)
	set(wip_right,wip_R)
end