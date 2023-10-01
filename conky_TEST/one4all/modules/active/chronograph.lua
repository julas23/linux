#use in conkyrc

#lua_load /path/Chronograph.lua
#lua_draw_hook_pre main
#TEXT


-- INDEX (use find with):

-- ###### 12 OR 24 CLOCK FACE
-- SET BORDER OPTIONS ######  ALL CLOCKS

-- ### START CLOCK A ######################################
-- MARKS AROUND CLOCK A -- Large Main 24 HR Clock
-- CLOCK A HOUR HAND
-- CLOCK A MINUTE HAND SETUP
-- CLOCK A SECOND HAND SETUP
-- CLOCK A ###### 24 HR TIME

-- ### START DIAL B ### Top - Week Day Names Dial #########
-- ### START DIAL C ### Right - Month Names Dial ##########
-- ### START DIAL D ### Left - Day Numbers Dial ###########

-- ### START CLOCK E ######################################
-- MARKS AROUND CLOCK E -- Bottom - 12 HR Clock
-- CLOCK E HOUR HAND
-- CLOCK E MINUTE HAND SETUP
-- CLOCK E SECOND HAND SETUP
-- CLOCK E ###### 12 HR TIME

NOTE:  Putting ### CLOCK A ### last insures that it's functions are written
       over the other dials.
]]

require 'cairo'

function conky_main()
if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
cr = cairo_create(cs)
-- ########################################################
-- SETTINGS AREA
-- local cpu=conky_parse("${cpu}")
-- local red-1=conky_parse("${image ~/Conky/images/red_1.png -p 0,0 -s 35x35}")

-- ###### 12 OR 24 CLOCK FACE #############################
local clock_type_A=12 -- Large Main 24 HR Clock
local clock_type_E=12 -- Bottom - 12 HR Clock

-- ###### CLOCK SETTINGS ##################################
-- SET BORDER OPTIONS FOR "CLOCKS" ########################
local clock_border_width=0
-- set color and alpha for clock border
local cbr,cbg,cbb,cba=1,1,1,1  -- full opaque white
-- gap from clock border to minute marks
local b_to_m=1

-- ########################################################
-- ### START DIAL B ### Top - Week Day Names Dial #########
-- DIAL POSITION FOR TEXT
local center_x=175
local center_y=95
local radius=50
-- FONT
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, 12)
cairo_set_source_rgba (cr,1,1,1,1) --(cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
-- TABLE OF TEXT -- in order
text_days={"SUN","MON","TUE","WED","THR","FRI","SAT",}
-- text_days={"DOM","LUN","MAR","MIE","JUE","VIE","SAB",}
for i=1,7 do
-- work out points
local point=(math.pi/180)*((360/7)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=text_days[i]--gets text from table
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end
-- INNER POINTS POSITION, radius smaller than text circle
local radius=35
for i=1,7 do
local point=(math.pi/180)*((360/7)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,1,0,2*math.pi)
cairo_stroke (cr)
end
-- DRAW HAND -- snaps to current day of week
local hand_length=30
local day_number=tonumber(os.date("%w"))
local point=(math.pi/180)*((360/7)*(day_number))
local x=0+hand_length*(math.sin(point))
local y=0-hand_length*(math.cos(point))
local hand_width=2
cairo_move_to (cr,center_x,center_y)
cairo_line_to (cr,center_x+x,center_y+y)
cairo_stroke (cr)
-- ### END DIAL B #########################################

-- ########################################################
-- ### START DIAL C ### Right - Month Names Dial ##########
-- DIAL POSITION FOR TEXT
local center_x=260
local center_y=175
local radius=45
-- FONT
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, 12)
cairo_set_source_rgba (cr,1,1,1,1) --(cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
-- TABLE OF TEXT -- in order
text_days={"JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC",}
-- text_days={"ENE","FEB","MAR","ABR","MAY","JUN","JUL","AGO","SEP","OCT","NOV","DIC",}
for i=1,12 do
-- OUTTER POINTS POSTION FOR TEXT
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=text_days[i]--gets text from table
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end
-- INNER POINTS POSITION, radius smaller than text circle
local radius=32
for i=1,12 do
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,1,0,2*math.pi)
cairo_stroke (cr)
end
-- DRAW HAND -- snaps to current month
local this_month=tonumber(os.date("%m"))
local hand_length=28 --radius for this calculation
local point=(math.pi/180)*((360/12)*(this_month-1))
local x=0+hand_length*(math.sin(point))
local y=0-hand_length*(math.cos(point))
cairo_move_to (cr,center_x,center_y)
cairo_line_to (cr,center_x+x,center_y+y)
cairo_stroke (cr)

-- ### END CLOCK C ########################################

-- ########################################################
-- ### START DIAL D ### Left - Day Numbers Dial ###########
-- GET NUMBER OF DAYS IN CURRENT MONTH
-- calculate Feb, then set up table
year4num=os.date("%Y")
t1=os.time({year=year4num,month=03,day=01,hour=00,min=0,sec=0});
t2=os.time({year=year4num,month=02,day=01,hour=00,min=0,sec=0});
febdaynum=tonumber((os.difftime(t1,t2))/(24*60*60))
-- MONTH TABLE
monthdays={31,febdaynum,31,30,31,30,31,31,30,31,30,31}
this_month=tonumber(os.date("%m"))
number_days=monthdays[this_month]
-- TEXT positioning
local center_x=95
local center_y=175
local radius=50
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, 8)
cairo_set_source_rgba (cr,1,1,1,1) --(cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
for i=1,number_days do
-- OUTTER POINTS POSTION FOR TEXT
local point=(math.pi/180)*((360/number_days)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=i
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end
-- INNER POINTS POSITION, radius smaller than text circle
local radius=40
for i=1,number_days do
local point=(math.pi/180)*((360/number_days)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,1,0,2*math.pi)
cairo_stroke (cr)
end
-- DRAW HAND -- snaps to current DAY
local this_day=tonumber(os.date("%d"))
local hand_length=35--radius for this calculation
local point=(math.pi/180)*((360/number_days)*(this_day-1))
local x=0+hand_length*(math.sin(point))
local y=0-hand_length*(math.cos(point))
cairo_move_to (cr,center_x,center_y)
cairo_line_to (cr,center_x+x,center_y+y)
cairo_stroke (cr)
-- ### END CLOCK D ########################################

-- ########################################################
-- ### START CLOCK E ######################################
-- MARKS AROUND CLOCK E -- Bottom - 12 HR Clock
local number_marks_E=12
-- set mark length
local m_length_E=0
-- set mark width
local m_width_E=0
-- set mark line cap type
local m_cap=CAIRO_LINE_CAP_ROUND
-- set mark color and alpha,red blue green alpha
local mr,mg,mb,ma=1,1,0,1-- opaque white
-- SETUP HOUR HANDS #######################################
-- CLOCK E HOUR HAND
-- set length of hour hand
hh_length_E=25
-- set hour hand width
hh_width_E=2
-- set hour hand line cap
hh_cap=CAIRO_LINE_CAP_ROUND
-- set hour hand color
hhr,hhg,hhb,hha=1,1,0,1-- fully opaque white
-- SETUP MINUTE HANDS #####################################
-- CLOCK E MINUTE HAND SETUP
-- set length of minute hand
mh_length_E=35
-- set minute hand width
mh_width_E=2
-- set minute hand line cap
mh_cap=CAIRO_LINE_CAP_ROUND
-- set minute hand color
mhr,mhg,mhb,mha=1,1,0,1-- fully opaque white
-- SETUP SECOND HANDS #####################################
-- CLOCK E SECOND HAND SETUP
-- set length of seconds hand
sh_length_E=32
-- set hour hand width
sh_width_E=1
-- set hour hand line cap
sh_cap=CAIRO_LINE_CAP_ROUND
-- set seconds hand color
shr,shg,shb,sha=1,0,0,1-- fully opaque red
-- CLOCK E ###### 12 HR TIME ##############################
-- CLOCK SETTINGS
clock_radius=45
clock_centerx=175
clock_centery=260
-- DRAWING CODE
-- DRAW BORDER
cairo_set_source_rgba (cr,cbr,cbg,cbb,cba)
cairo_set_line_width (cr,clock_border_width)
cairo_arc (cr,clock_centerx,clock_centery,clock_radius,0,2*math.pi)
cairo_stroke (cr)
-- DRAW MARKS
-- stuff that can be moved outside of the loop, needs only be set once
-- calculate end and start radius for marks
m_end_rad=clock_radius-b_to_m
m_start_rad=m_end_rad-m_length_E
-- set line cap type
cairo_set_line_cap  (cr, m_cap)
-- set line width
cairo_set_line_width (cr,m_width_E)
-- set color and alpha for marks
cairo_set_source_rgba (cr,mr,mg,mb,ma)
-- START LOOP FOR SECOND MARKS
for i=1,number_marks_E do
-- drawing code using the value of i to calculate degrees
-- calculate start point for 12/24 hour mark
radius=m_start_rad
point=(math.pi/180)*((i-1)*(360/number_marks_E))
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- set start point for line
cairo_move_to (cr,clock_centerx+x,clock_centery+y)
-- calculate end point for 12/24 hour mark
radius=m_end_rad
point=(math.pi/180)*((i-1)*(360/number_marks_E))
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- set path for line
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- draw the line
cairo_stroke (cr)
end-- of for loop
--[[ TIME CALCULATIONS CLOCK E
if clock_type_E==12 then
hours=tonumber(os.date("%I"))
-- convert hours to seconds
h_to_s=hours*60*60
elseif clock_type_E==24 then
hours=tonumber(os.date("%H"))
-- convert hours to seconds
h_to_s=hours*60*60
end
minutes=tonumber(os.date("%M"))
-- convert minutes to seconds
m_to_s=minutes*60
-- get current seconds
seconds=tonumber(os.date("%S"))
-- DRAW HOUR HAND
-- get hours minutes seconds as just seconds and draw it
hsecs=h_to_s+m_to_s+seconds
-- calculate degrees for each second
hsec_degs=hsecs*(360/(60*60*clock_type_E))-- use equation ~ eliminate decimals
-- set radius to calculate hand points
radius=hh_length_E
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of minute hand
point=(math.pi/180)*hsec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes and draw line
cairo_set_line_width (cr,hh_width_E)
cairo_set_source_rgba (cr,hhr,hhg,hhb,hha)
cairo_set_line_cap  (cr, hh_cap)
cairo_stroke (cr)
-- DRAW MINUTE HAND
-- get minutes and seconds as seconds
msecs=m_to_s+seconds
-- calculate degrees for each second
msec_degs=msecs*0.1
-- set radius to calculate hand points
radius=mh_length_E
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of minute hand
point=(math.pi/180)*msec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes and draw line
cairo_set_line_width (cr,mh_width_E)
cairo_set_source_rgba (cr,mhr,mhg,mhb,mha)
cairo_set_line_cap  (cr, mh_cap)
cairo_stroke (cr)
-- DRAW SECOND HAND
-- calculate degrees for each second
sec_degs=seconds*6
-- set radius to calculate hand points
radius=sh_length_E
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of seconds hand
point=(math.pi/180)*sec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes
cairo_set_line_width (cr,sh_width_E)
cairo_set_source_rgba (cr,shr,shg,shb,sha)
cairo_set_line_cap  (cr, sh_cap)
cairo_stroke (cr)


-- POSITION FOR TEXT HOUR NUMBERS
local center_x=175
local center_y=260
local radius=45
-- FONT
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, 12)
cairo_set_source_rgba (cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
-- TABLE OF TEXT -- in order
--text_days={"12","01","02","03","04","05","06","07","08","09","10","11",}
-- FOR A 12 HOUR CLOCK WITH THE NUMBERS 13-00
text_days={"00","13","14","15","16","17","18","19","20","21","22","23",}
for i=1,12 do
-- OUTTER POINTS POSTION FOR TEXT
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=text_days[i]--gets text from table
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end
-- INNER POINTS POSITION, radius smaller than text circle
local radius=32
for i=1,12 do
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,1,0,2*math.pi)
cairo_stroke (cr)
end ]]

-- ### END CLOCK E ########################################




-- ########################################################
-- ### START CLOCK A ######################################
-- SET MARKS ##############################################
-- MARKS AROUND CLOCK A -- Large Main 24 HR Clock
local number_marks_A=12
-- set mark length
local m_length_A=0
-- set mark width
local m_width_A=0
-- set mark line cap type
local m_cap=CAIRO_LINE_CAP_ROUND
-- set mark color and alpha,red blue green alpha
local mr,mg,mb,ma=1,1,1,1-- opaque white
-- SETUP HOUR HANDS #######################################
-- CLOCK A HOUR HAND
-- set length of hour hand
hh_length_A=130
-- set hour hand width
hh_width_A=3
-- set hour hand line cap
hh_cap=CAIRO_LINE_CAP_ROUND
-- set hour hand color
hhr,hhg,hhb,hha=1,1,1,.5-- fully opaque white
-- SETUP MINUTE HANDS #####################################
-- CLOCK A MINUTE HAND SETUP
-- set length of minute hand
mh_length_A=145
-- set minute hand width
mh_width_A=2
-- set minute hand line cap
mh_cap=CAIRO_LINE_CAP_ROUND
-- set minute hand color
mhr,mhg,mhb,mha=1,1,1,.5-- fully opaque white
-- SETUP SECOND HANDS #####################################
-- CLOCK A SECOND HAND SETUP
-- set length of seconds hand
sh_length_A=150
-- set hour hand width
sh_width_A=2
-- set hour hand line cap
sh_cap=CAIRO_LINE_CAP_ROUND
-- set seconds hand color
shr,shg,shb,sha=1,0,0,1-- fully opaque red
-- CLOCK A ###### 12 HR TIME ##############################
-- CLOCK SETTINGS
clock_radius=200
clock_centerx=175
clock_centery=175
-- DRAWING CODE
-- DRAW BORDER
cairo_set_source_rgba (cr,cbr,cbg,cbb,cba)
cairo_set_line_width (cr,clock_border_width)
cairo_arc (cr,clock_centerx,clock_centery,clock_radius,0,2*math.pi)
cairo_stroke (cr)
-- DRAW MARKS
-- stuff that can be moved outside of the loop, needs only be set once
-- calculate end and start radius for marks
m_end_rad=clock_radius-b_to_m
m_start_rad=m_end_rad-m_length_A
-- set line cap type
cairo_set_line_cap  (cr, m_cap)
-- set line width
cairo_set_line_width (cr,m_width_A)
-- set color and alpha for marks
cairo_set_source_rgba (cr,mr,mg,mb,ma)
-- START LOOP FOR HOUR MARKS
for i=1,number_marks_A do
-- drawing code using the value of i to calculate degrees
-- calculate start point for 12/24 hour mark
radius=m_start_rad
point=(math.pi/180)*((i-1)*(360/number_marks_A))
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- set start point for line
cairo_move_to (cr,clock_centerx+x,clock_centery+y)
-- calculate end point for 12/24 hour mark
radius=m_end_rad
point=(math.pi/180)*((i-1)*(360/number_marks_A))
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- set path for line
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- draw the line
cairo_stroke (cr)
end-- of for loop
-- HOUR MARKS
-- TIME CALCULATIONS CLOCK A
if clock_type_A==12 then
hours=tonumber(os.date("%I"))
-- convert hours to seconds
h_to_s=hours*60*60
elseif clock_type_A==24 then
hours=tonumber(os.date("%H"))
-- convert hours to seconds
h_to_s=hours*60*60
end
minutes=tonumber(os.date("%M"))
-- convert minutes to seconds
m_to_s=minutes*60
-- get current seconds
seconds=tonumber(os.date("%S"))
-- DRAW HOUR HAND
-- get hours minutes seconds as just seconds
hsecs=h_to_s+m_to_s+seconds
-- calculate degrees for each second
hsec_degs=hsecs*(360/(60*60*clock_type_A))-- use equation ~ eliminate decimals
-- set radius to calculate hand points
radius=hh_length_A
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of hour hand
point=(math.pi/180)*hsec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes and draw line
cairo_set_line_width (cr,hh_width_A)
cairo_set_source_rgba (cr,hhr,hhg,hhb,hha)
cairo_set_line_cap  (cr, hh_cap)
cairo_stroke (cr)
-- DRAW MINUTE HAND
-- get minutes and seconds just as seconds
msecs=m_to_s+seconds
-- calculate degrees for each second
msec_degs=msecs*0.1
-- set radius to calculate hand points
radius=mh_length_A
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of minute hand
point=(math.pi/180)*msec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes and draw line
cairo_set_line_width (cr,mh_width_A)
cairo_set_source_rgba (cr,mhr,mhg,mhb,mha)
cairo_set_line_cap  (cr, mh_cap)
cairo_stroke (cr)
-- DRAW SECOND HAND
--[[
-- calculate degrees for each second
sec_degs=seconds*6
-- set radius to calculate hand points
radius=sh_length_A
-- set start line coordinates, the center of the circle
cairo_move_to (cr,clock_centerx,clock_centery)
-- calculate coordinates for end of seconds hand
point=(math.pi/180)*sec_degs
x=0+radius*(math.sin(point))
y=0-radius*(math.cos(point))
-- describe the line we will draw
cairo_line_to (cr,clock_centerx+x,clock_centery+y)
-- set up line attributes
cairo_set_line_width (cr,sh_width_A)
cairo_set_source_rgba (cr,shr,shg,shb,sha)
cairo_set_line_cap  (cr, sh_cap)
cairo_stroke (cr)
]]
-- ####################################################################
-- part of a second hand

--position
local center_x=175
local center_y=175
--get seconds value
local seconds=tonumber(os.date("%S"))
--calculate rotation of second hand in degrees
local arc=(math.pi/180)*((360/60)*seconds)
--calculate point 1
local radius1=100
local x1=0+radius1*math.sin(arc)
local y1=0-radius1*math.cos(arc)
--calculate point 2
local radius2=151
local x2=0+radius2*math.sin(arc)
local y2=0-radius2*math.cos(arc)
--draw line connecting points
cairo_move_to (cr, center_x+x1,center_y+y1)
cairo_line_to (cr, center_x+x2, center_y+y2)
cairo_set_source_rgba (cr,255/255,0/255,0/255,1)
cairo_stroke (cr)
-- ####################################################################

-- POSITION FOR TEXT HOUR NUMBERS
local center_x=175
local center_y=175
local radius=165
-- FONT
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD);
cairo_set_font_size (cr, 16)
cairo_set_source_rgba (cr,1,1,1,1) --(cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
-- TABLE OF TEXT -- in order
text_days={"12","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23",}
for i=1,12 do
-- OUTTER POINTS POSTION FOR TEXT
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=text_days[i]--gets text from table
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end

-- POSITION FOR TEXT HOUR NUMBERS
local center_x=175
local center_y=175
local radius=160
-- FONT
cairo_select_font_face (cr, "Santana", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, 12)
cairo_set_source_rgba (cr,1,1,1,1) --(cr,194/255,204/255,255/255,1)	-- (cr,1,1,1,1)
-- TABLE OF TEXT -- in order
text_days={"","1","2","3","4","","6","7","8","9","","11","12","13","14","","16","17","18","19","","21","22","23","24","","26","27","28","29","","31","32","33","34","","36","37","38","39","","41","42","43","44","","46","47","48","49","","51","52","53","54","","56","57","58","59","",}
for i=1,60 do
-- OUTTER POINTS POSTION FOR TEXT
local point=(math.pi/180)*((360/60)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
-- CALCULATE CENTRE OF TEXT
local text=text_days[i]--gets text from table
local extents=cairo_text_extents_t:create()
cairo_text_extents(cr,text,extents)
local width=extents.width
local height=extents.height
cairo_move_to(cr,center_x+x-(width/2),center_y+y+(height/2))
cairo_show_text (cr, text)
cairo_stroke (cr)
end

-- INNER POINTS POSITION, radius smaller than text circle
local radius=150
for i=1,60 do
local point=(math.pi/180)*((360/60)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,1,0,2*math.pi)
cairo_stroke (cr)
end
--[[ HOUR POINTS CIRCLES,  ##########Uncoment section to draw rings around numbers
local radius=162
for i=1,60 do
local point=(math.pi/180)*((360/12)*(i-1))
local x=0+radius*(math.sin(point))
local y=0-radius*(math.cos(point))
cairo_arc (cr,center_x+x,center_y+y,12,0,2*math.pi)
cairo_stroke (cr)
end]]
-- ### END CLOCK A ########################################



-- ########################################################
cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
end-- end main function
