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
 (idle, fivein, fiveout, tenin, tenout, fifteenin, fifteenout, enoughin, morein, reset);

    SIGNAL Currstate, Nextstate: StateType;

BEGIN

    StateReg: PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            Currstate <= Nextstate;
        END IF;
    END PROCESS;

    CombLogic: Process (Input, Currstate)
    BEGIN
        case Currstate IS
            When idle =>
                Permit <= '0';
                ReturnChange <= '0';
                if (Input = "000" or Input = "111") THEN
                    Nextstate <= idle;
                elsif (Input = "001") THEN
                    Nextstate <= fivein;
                elsif (Input = "010") THEN
                    Nextstate <= tenin;
                elsif (Input = "100") then
                    Nextstate <= enoughin;
                end if;

            When fivein =>
                if (Input = "000") THEN
                    Nextstate <= fiveout;
                else
                    Nextstate <= fivein;
                end if;

            When fiveout =>
                if (Input = "000") THEN
                    Nextstate <= fiveout;
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
                if (Input = "000") THEN
                    Nextstate <= tenout;
                else
                    Nextstate <= tenin;
                end if;

            When tenout =>
                if (Input = "000") THEN
                    Nextstate <= tenout;
                elsif (Input = "001") THEN
                    Nextstate <= fifteenin;
                elsif (Input = "010") THEN
                    Nextstate <= enoughin;
                elsif (Input = "100") then
                    Nextstate <= morein;
                elsif (Input = "111") then
                    Nextstate <= reset;
                end if;

            When fifteenin =>
                if (Input = "000") THEN
                    Nextstate <= fifteenout;
                else
                    Nextstate <= fifteenin;
                end if;

            When fifteenout =>
                if (Input = "000") THEN
                    Nextstate <= fifteenout;
                elsif (Input = "001") THEN
                    Nextstate <= enoughin;
                elsif (Input = "010" or Input = "100") THEN
                    Nextstate <= morein;
                elsif (Input = "111") then
                    Nextstate <= reset;
                end if;

            When enoughin =>
                Permit <= '1';
                ReturnChange <= '0';
                Nextstate <= idle;

            When morein =>
                Permit <= '1';
                ReturnChange <= '1';
                Nextstate <= idle;

            When reset =>
                Permit <= '0';
                ReturnChange <= '1';
                Nextstate <= idle;
        end case;
    end Process CombLogic;
END Behavioral;