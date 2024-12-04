----------------------------------------------------------------------
-- Digital Design 101 Lab Assignment 1 - S22
-- LFDetector Behavioral Model
----------------------------------------------------------------------
-- Student First Name : Chris
-- Student Last Name : Cyr
-- Student ID : 12436037
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY LFDetector_behav IS
   PORT (Fuel3, Fuel2, Fuel1, Fuel0: IN std_logic;
         FuelWarningLight: OUT std_logic);
END LFDetector_behav;

ARCHITECTURE Behavior OF LFDetector_behav IS

-- DO NOT modify any signals, ports, or entities above this line
-- add your code below this line
-- put your code in a PROCESS
-- use AND/OR/NOT keywords for behavioral function

BEGIN
  FuelWarningLight <= Fuel3 NOR Fuel2;
END Behavior;