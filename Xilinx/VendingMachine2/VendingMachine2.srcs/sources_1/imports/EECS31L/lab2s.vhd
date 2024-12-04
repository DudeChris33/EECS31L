----------------------------------------------------------------------
-- EECS31L Assignment 2
-- FSM Structural Model
----------------------------------------------------------------------
-- Student First Name : Chris
-- Student Last Name : Cyr
-- Student ID : 12436037
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Lab2s_FSM IS
    Port (Input : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
         Clk : in  STD_LOGIC;
         Permit : out  STD_LOGIC;
         ReturnChange : out  STD_LOGIC);
END Lab2s_FSM;

ARCHITECTURE Structural OF Lab2s_FSM IS

    SUBTYPE StateType is std_logic_vector(3 DOWNTO 0);

    SIGNAL Currstate, Nextstate: StateType := "0000";

BEGIN
    StateReg: PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate AFTER 4ns;
        END IF;
    END PROCESS StateReg;

    CombLogic: Process (Input, Currstate)
    BEGIN
        Nextstate(3) <= (Input(0) and Currstate(2) and Currstate(1) and Currstate(0)) or (Input(0) and Currstate(3)) or (Input(1) and Currstate(2) and Currstate(0)) or (Input(1) and Currstate(3)) or (Input(2) and Currstate(0)) or (Input(2) and not Input(1) and not Currstate(2) and not Currstate(1));
        Nextstate(2) <= (not Input(2) and not Input(1) and not Input(0) and not Currstate(3) and Currstate(2)) or (Currstate(2) and not Currstate(0)) or (Input(0) and not Currstate(3) and not Currstate(2) and Currstate(0)) or (not Input(2) and not Input(1) and not Currstate(3) and not Currstate(1) and Currstate(0)) or (Input(0) and Currstate(3) and Currstate(1)) or (not Input(2) and Input(1) and not Currstate(3) and not Currstate(1) and not Currstate(0)) or (Input(1) and not Currstate(3) and not Currstate(2) and Currstate(0)) or (Input(1) and Currstate(3) and Currstate(1)) or (Input(2) and Currstate(3) and Currstate(1)) or (Input(1) and Input(0) and not Currstate(3) and Currstate(0));
        Nextstate(1) <= (not Input(2) and not Input(1) and not Input(0) and not Currstate(3) and Currstate(1)) or (Currstate(1) and not Currstate(0)) or (not Input(2) and Input(0) and not Currstate(3) and not Currstate(2) and not Currstate(0)) or (Input(0) and not Currstate(3) and not Currstate(1) and Currstate(0)) or (Input(0) and Currstate(3) and Currstate(1)) or (not Input(2) and not Input(0) and not Currstate(3) and not Currstate(2) and Currstate(0)) or (Input(1) and Currstate(3) and Currstate(1)) or (Input(2) and Currstate(3) and Currstate(1)) or (Input(1) and Input(0) and not Currstate(3) and Currstate(0));
        Nextstate(0) <= (Input(2) and Currstate(0)) or (not Input(2) and not Input(1) and not Input(0) and not Currstate(3) and Currstate(1)) or (not Input(2) and not Input(1) and not Input(0) and not Currstate(3) and Currstate(2)) or (Input(0) and Currstate(3) and Currstate(0)) or (not Input(0) and not Currstate(3) and Currstate(2) and Currstate(1) and Currstate(0)) or (Input(1) and Currstate(3) and Currstate(0));
        Permit <= (Currstate(3) and not Currstate(2) and not Currstate(1)) after 5.6ns;
        ReturnChange <= (Currstate(3) and Currstate(0)) after 5.6ns;
    end Process CombLogic;
END Structural;