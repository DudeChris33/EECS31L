----------------------------------------------------------------------
-- EECS31L Assignment 2
-- FSM Behavioral Model
----------------------------------------------------------------------
-- Student First Name : Chris
-- Student Last Name : Cyr
-- Student ID : 12436037
----------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Lab2b_FSM is
    Port ( Input : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
         Clk : in  STD_LOGIC;
         Permit : out  STD_LOGIC;
         ReturnChange : out  STD_LOGIC);
end Lab2b_FSM;

architecture Behavioral of Lab2b_FSM is

    -- DO NOT modify any signals, ports, or entities above this line
    -- Recommendation: Create 2 processes (one for updating state status and the other for describing transitions and outputs)
    -- Figure out the appropriate sensitivity list of both the processes.
    -- Use CASE statements and IF/ELSE/ELSIF statements to describe your processes.

    TYPE StateType is
 (nonein, fivein, tenin, fifteenin, twentyin, morein, reset);

    SIGNAL Currstate, Nextstate: StateType;

BEGIN

    StateReg: PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate;
        END IF;
    END PROCESS;

    CombLogic: Process (Currstate, Input)
    BEGIN
        case Currstate IS
            When nonein =>
                Permit <= '0';
                ReturnChange <= '0';
                if (Input = "000" or Input = "111") THEN
                    Nextstate <= nonein;
                elsif (Input = "001") THEN
                    Nextstate <= fivein;
                elsif (Input = "010") THEN
                    Nextstate <= tenin;
                elsif (Input = "100") then
                    Nextstate <= twentyin;
                end if;

            When fivein =>
                Permit <= '0';
                ReturnChange <= '0';
                if (Input = "000") THEN
                    Nextstate <= fivein;
                elsif (Input = "001") THEN
                    Nextstate <= tenin;
                elsif (Input = "010") THEN
                    Nextstate <= fifteenin;
                elsif (Input = "100") then
                    Nextstate <= morein;
                elsif (Input = "111") then
                    Nextstate <= reset;
                end if;

            When tenin =>
                Permit <= '0';
                ReturnChange <= '0';
                if (Input = "000") THEN
                    Nextstate <= tenin;
                elsif (Input = "001") THEN
                    Nextstate <= fifteenin;
                elsif (Input = "010") THEN
                    Nextstate <= twentyin;
                elsif (Input = "100") then
                    Nextstate <= morein;
                elsif (Input = "111") then
                    Nextstate <= reset;
                end if;

            When fifteenin =>
                Permit <= '0';
                ReturnChange <= '0';
                if (Input = "000") THEN
                    Nextstate <= fifteenin;
                elsif (Input = "001") THEN
                    Nextstate <= twentyin;
                elsif (Input = "010") THEN
                    Nextstate <= morein;
                elsif (Input = "100") then
                    Nextstate <= morein;
                elsif (Input = "111") then
                    Nextstate <= reset;
                end if;

            When twentyin =>
                Permit <= '1';
                ReturnChange <= '0';
                if (Input = "000") then
                    NextState <= twentyin;
                else
                    Nextstate <= nonein;
                end if;

            When morein =>
                Permit <= '1';
                ReturnChange <= '1';
                if (Input = "000") then
                    NextState <= morein;
                else
                    Nextstate <= nonein;
                end if;

            When reset =>
                Permit <= '0';
                ReturnChange <= '1';
                if (Input = "000") then
                    NextState <= reset;
                else
                    Nextstate <= nonein;
                end if;
        end case;
    end Process CombLogic;

    -- next0 <= (not c0 and c1 and c2 and i2) or (not c0 and c1 and i1) or (not c0 and i0 and not i1) or (not c0 and c2 and i1 and i2);
    -- next1 <= (not c0 and not c1 and c2 and i2) or (not c0 and c1 and not i0 and not i1 and not i2) or (not c0 and not c1 and not i0 and i1) or (c1 and not c2 and not i0 and not i1) or (not c0 and c1 and i1 and i2);
    -- next2 <= (not c0 and c2 and not i2) or (not c0 and not c2 and not i0 and i2) or (not c0 and c2 and i1) or (not c0 and c1 and i0);
    -- permit <= (not c0 and i0 and not i1) or (not c0 and c1 and not i0 and i1) or (not c0 and c1 and c2 and not i0 and i2);
    -- return <= (not c0 and c2 and i0) or (not c0 and c1 and c2 and i1) or (not c0 and c1 and i0);

END Behavioral;