print('----------------------------')
print('       Bath Control         ')
print('      start in 5 sec        ')
print('for update, disable timer 0 ')
print('----------------------------')

tmr.alarm(0, 2000, tmr.ALARM_SINGLE, function() dofile("Controller.lua") end)
