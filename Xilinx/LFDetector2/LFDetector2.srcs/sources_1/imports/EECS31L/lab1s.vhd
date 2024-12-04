----------------------------------------------------------------------
-- Digital Design 101 Lab Assignment 1 (Structural) - S22
-- LFDetector Structural Model
----------------------------------------------------------------------
-- Student First Name : Chris
-- Student Last Name : Cyr
-- Student ID : 12436037
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY NAND2 IS
   PORT (x: IN std_logic;
         y: IN std_logic;
         F: OUT std_logic);
END NAND2;  

ARCHITECTURE behav OF NAND2 IS
BEGIN
   PROCESS(x, y)
   BEGIN
      F <= NOT (x AND y) AFTER 1.4 ns; 
   END PROCESS;
END behav;
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY LFDetector_structural IS
   PORT (Fuel3, Fuel2, Fuel1, Fuel0: IN std_logic;
         FuelWarningLight: OUT std_logic);
END LFDetector_structural;

ARCHITECTURE Structural OF LFDetector_structural IS

    COMPONENT NAND2 IS
        PORT (x: IN std_logic;
              y: IN std_logic;
              F: OUT std_logic);
    END COMPONENT;
    
    SIGNAL wire_1, wire_2, wire_3, wire_4 : std_logic;

BEGIN
    NAND_1 : NAND2 PORT MAP (Fuel3, Fuel3, wire_1);
    NAND_2 : NAND2 PORT MAP (Fuel2, Fuel2, wire_2);
    NAND_3 : NAND2 PORT MAP (wire_1, wire_2, wire_3);
    NAND_4 : NAND2 PORT MAP (wire_3, wire_3, wire_4);
    FuelWarningLight <= wire_4;
END Structural;