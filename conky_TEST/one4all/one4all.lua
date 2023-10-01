 --[[
 Conky LUA one4all script - loads various scripts as modules without any need to merge it's codes by user. Just copy module from available/ to active/ directory and configure each one to your needs and they will work without any further hustle.
 
 0.2.7 - (12.07.2012) added print_text to flibs and time2angle function don't all "os.date()" if not needed
 0.2.6 - (21.06.2012) removed draw_bg interface for config-rc (only module remains)
 0.2.5 - (21.06.2012) added draw_bg function, draw_bg module and draw_bg interface to use it in conky-rc config file
 0.2.4 - (15.06.2012) added changelog to code for public release purpose and hex/dec conversion to functions
 0.2.3 - (19.04.2012) modified start up script so it waits for COMPIZ to start
 0.2.2 - (19.04.2012) changed _conky_path from local to global and added data/ directory for some additional data for modules
 0.2.1 - (7.04.2012) added 12/24 type settings to time2angle function
 0.2.0 - (6.04.2012) added automatic function modules loading, changed faulty names from previous release and removing modules out from main code release to separate packages
 0.1.2 - (5.04.2012) changes in airclock module and modules names
 0.1.0 - (10.03.2012) initial release
 ]]--
 
 do
 	_conky_path = string.gsub(conky_config, "(/.*/)(\..*)$", "%1", 1)
 	package.path = _conky_path .. 'modules/active/?.module'
 	package.path = package.path .. ";" .. _conky_path .. 'flibs/active/?.flib'
 	
 	require 'cairo'
 	require 'imlib2'
 	require 'one4all_main'
 
 	local function _make_list(_name)
 		local _file_list = {}
 		local j = 0
 		for i in string.gmatch(one4all_main.os_capture('ls -1 ' .. _conky_path .. '/' .. _name .. 's/active'), '%S+\.' .. _name) do
 			local i, n = string.gsub(i, '\.' .. _name, '')
 			j = j + 1
 			_file_list[j] = i
 		end	
 		for i in pairs(_file_list) do require(_file_list[i]) end
 		return _file_list
 	end
 	
 	local _active_list = {}
 	_active_list = _make_list('flib')
 	local _active_list = {}
 	_active_list = _make_list('module')
 	
 
 
 	function conky_main()
 		if tonumber(conky_parse("${updates}")) < 5 then return end
 		cr, cs, conky_window = one4all_cairo.window_hook(cr, cs)
 		
 		for i in pairs(_active_list) do
 			assert(loadstring(_active_list[i] .. '.main()'))()
 		end
 	end
 end
