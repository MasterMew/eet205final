'Jared Geiner
'EET205 12/14/2021
'Final Project Picaxe Program


#NO_DATA
#NO_TABLE

adcsetup = 2
settimer t1s_16
timer = $FFFF
symbol emode = b9
b9 = 0




output b.7, b.0, b.6, b.5, b.4, b.3, c.5,c.4

symbol heartbeat = b.7
symbol lcd = b.0
symbol dlightA = b.6
symbol dlightB = b.5
symbol lights = b.4
symbol dlock = b.3
symbol cold = c.5
symbol heat = c.4

main:
if emode = 1 then 
	high dlightA
	low dlightB
	sound c.0, (110, 100)
endif

readadc 0, b0 'Read the photoresistor
serout c.6, t9600_8, (b0)  

'if dark lights on
if b0 > 80 then
	low lights
	serout c.6, t9600_8, ("B")
else if b0 < 11 then
	high lights
	serout c.6, t9600_8, ("A")
end if


readadc 1, b1 'Read the thermistor

serout c.6, t9600_8, (b1)

'if hot  run air
if b1 > 130 then
	high cold
elseif b1 < 122 then
	low cold
endif
'if cold run heat
if b1 < 90 then
	high heat
elseif b1 >102 then
	low heat
endif





'When receiving data run mail call sub
if hserinflag != 0 then
pause 25
get 0, b10
gosub mail_call
end if


if emode = 1 then
	low dlightA
	high dlightB
	sound c.0, (110, 100)
endif

goto main


'mail call sub
mail_call:
if b10 = "O" then
	gosub open
	high dlightA
	low dlock
else if b10 = "C" then
	gosub closed
	low dlightA
	high dlock
else if b10 = "E" then
	gosub emergency
	low dlock
	emode = 1
endif
return

'sub to write closed sign
closed:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5B)
serout lcd, n9600_8, ("CLOSED")
return

'sub to write open sign
open:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5C)
serout lcd, n9600_8, ("OPEN")
return

'sub to write emergency sign
emergency:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5A)
serout lcd, n9600_8, ("EMERGENCY")
return

'Heartbeat interrupt
interrupt:

high heartbeat
pause 10
low heartbeat
timer = $FFFF

return