Here is a program for Advanced Digital Circuits course Final. 

To be private after finalization and submission.

Simply here for version control as well as professor quality of life benefits.


The Program:
  Is meant to use a picaxe 28x2 microcontroller to communicate through serial port interface back and forth with a computer running a VB form. This program will
  be a mock shopping mall that will have Heating and Cooling VIA a thermistor sending data to the form to show temp levels as well as LEDS to represent the system
  kicking in. There is also a photoresistor in place to measure light so that when it gets dark, it will light 4 leds in the mock parking lot representing the lamp
  posts found in parking lots. The form has 3 buttons in place to activate different statuses of the mall. There is open, close, and emergency, all of which will send
  a signal to the picaxe to write to a lcd screen the current state of the mall. There is a 12v relay which represents the mall door's locking mechanism as well as 2
  door lights which are affected by the status of the mall. When open, door will be unlocked and door lights will be on. When closed, door will be locked and door lights
  will be off. When in emergency mode, the door will be open and the door lights will flash on and off asynchronously. 
  
  While the picaxe is running, there is a watchdog chip that the picaxe is sending a heartbeat to. With this if the picaxe locked up and was unable to send the heartbeat,
  The watchdog would reset the chip. watchdog is a  max6373 chip.
