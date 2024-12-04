----------------------------------------------------------------------
-- EECS31L Assignment 3 - S'22
-- Locator Behavioral Model
----------------------------------------------------------------------
-- Student First Name : Your First Name
-- Student Last Name : Your Last Name
-- Student ID : Your Student ID
----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;


entity Locator_beh  is
    Port ( Clk : in  STD_LOGIC;
         Start : in  STD_LOGIC;
         Rst : in  STD_LOGIC;
         Loc : out  STD_LOGIC_VECTOR (15 downto 0);
         Done : out  STD_LOGIC);
end Locator_beh;

architecture Behavioral of Locator_beh  is

    TYPE regArray_type IS
 ARRAY (0 TO 7) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL regArray : regArray_type :=  (X"0000", X"000B", X"0023", X"0007", X"000A", X"0000", X"0000", X"0000");

    -- do not modify any code above this line
    -- additional variables/signals can be declared if needed below
    -- add your code starting here



    TYPE StateType is
 (zero, math, fin);
    SIGNAL Currstate, Nextstate: StateType := zero;
    
BEGIN
    StateReg: PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate;
        END IF;
    END PROCESS;

    CombLogic: Process (Start, Rst, Currstate)
    variable R1,R2,R3: std_logic_vector(31 downto 0) := X"00000000";
    BEGIN
        case Currstate IS
            When zero =>
                R1 := X"00000000"; R2 := X"00000000"; R3 := X"00000000";
                Loc <= X"0000"; Done <= '0';
                if (Start = '1') THEN
                    Nextstate <= math;
--                else
--                    Nextstate <= zero;
                end if;

            When math =>
                if (Rst = '0') THEN
                    R1 := regArray(2) * regArray(2);
                    R2 := regArray(1) * R1(15 downto 0);
                    R1 := "0" & R2(31 downto 1);
                    R2 := regArray(2) * regArray(3);
                    R3 := R1 + R2(31 downto 0);
                    R1 := R3 + regArray(4);
                    Loc <= R1(15 downto 0);
                    Nextstate <= fin;
                else
                    Nextstate <= zero;
                end if;

            When fin =>
                Done <= '1';
                Loc <= R1(15 downto 0);
                Nextstate <= zero;
        end case;
    end Process CombLogic;
END Behavioral;