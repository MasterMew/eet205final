'Jared Geiner
'EET205 12/14/2021
'Final Project Picaxe Program


#NO_DATA
#NO_TABLE

adcsetup = 2

settimer t1s_4
timer = $FFFF
toflag = 0
setintflags 0x80, 0x80

symbol emode = b9
emode = 0



output b.7, b.0, b.6, b.5, b.4, b.3, c.5,c.4, c.6

symbol heartbeat = b.7
symbol lcd = b.0
symbol dlightA = b.6
symbol dlightB = b.5
symbol lights = b.4
symbol dlock = b.3
symbol cold = c.5
symbol heat = c.4

'startup with mall closed
gosub closed
high dlock


hsersetup B9600_8, $9 ;?$9 sets the mode bits -
hserptr = 0
hserinflag = 0
b10 = 0x00
main:
if emode = 1 then 
	high dlightA
	low dlightB
	sound c.0, (110, 100)
endif

readadc 0, b0 'Read the photoresistor
 

'if dark lights on
if b0 > 80 then
	low lights
	serout c.6, t9600_8, ("B")
else if b0 < 11 then
	high lights
	serout c.6, t9600_8, ("A")
end if


readadc 1, b1 'Read the thermistor
'sertxd (#b1, cr, lf) 'for testing purposes
'serout c.6, t9600_8, ("T")

'serout c.6, t9600_8, (#b1)
gosub acUnit 
'if hot  run air
if b1 > 55 then
	high cold
elseif b1 < 50 then
	low cold
endif
'if cold run heat
if b1 < 35 then
	high heat
elseif b1 > 40 then
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
	high dlightB
	low dlock	
else if b10 = "C" then
	gosub closed
	low dlightA
	low dlightB
	high dlock
else if b10 = "E" then
	gosub emergency
	low dlock
	emode = 1
else if b10 = "B" then
	gosub batsignal
	low dlock
	
endif
hserptr = 0
hserinflag = 0
b10 = 0x00

return

'sub to write closed sign
closed:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5B)
serout lcd, n9600_8, ("CLOSED")
emode = 0
return

'sub to write open sign
open:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5C)
serout lcd, n9600_8, ("OPEN")
emode = 0
return

'sub to write emergency sign
emergency:
SEROUT lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10,0X5A)
serout lcd, n9600_8, ("EMERGENCY")
return

'subroutine for BIG Emergencies
batsignal:
serout lcd, n9600_8, (0x0C)
serout lcd, n9600_8, (0x10, 0x46)
serout lcd, n9600_8, (" /(_M_)` ")
serout lcd, n9600_8, (0x10, 0x5A)
serout lcd, n9600_8, ("|       |")
serout lcd, n9600_8, (0x10, 0x6F)
serout lcd, n9600_8, ("`/-V-`/")
return 
'subroutine to send a char over to vb in order to see temp changes
acUnit:

if b1 < 35 then
	serout c.6, t9600_8, ("a") 'HEAT ON value 33
elseif b1 >= 35 and b1 < 40 then
	serout c.6, t9600_8, ("b") 'value 38 no change
elseif b1 >= 40 and b1 < 45 then
	serout c.6, t9600_8, ("c") 'value 43 unit not running
elseif b1 >=45 and b1 < 50 then
	serout c.6, t9600_8, ("d") 'value 48 unit not running
elseif b1 >= 50 and b1 < 55 then
	serout c.6, t9600_8, ("e") ' value 53 no change
elseif b1 > 55 then
	serout c.6, t9600_8, ("f") ' value = 58 heat on
endif 
return

'Heartbeat interrupt
interrupt:

high heartbeat
pause 10
low heartbeat
timer = $FFFF
toflag = 0
setintflags 0x80, 0x80
return