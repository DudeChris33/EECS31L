----------------------------------------------------------------------
-- EECS31L Assignment 3
-- Locator Structural Model
----------------------------------------------------------------------
-- Student First Name : Chris
-- Student Last Name : Cyr
-- Student ID : 12436037
----------------------------------------------------------------------

---------- Components library ----------

---------- 8x16 Register File ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY RegFile IS
    PORT (R_Addr1, R_Addr2, W_Addr: IN std_logic_vector(2 DOWNTO 0);
         R_en, W_en: IN std_logic;
         Reg_Data1 : OUT std_logic_vector(15 DOWNTO 0);
         Reg_Data2 : OUT std_logic_vector(15 DOWNTO 0);
         W_Data: IN std_logic_vector(15 DOWNTO 0);
         Clk, Rst: IN std_logic);
END RegFile;

ARCHITECTURE Beh OF RegFile IS
    TYPE regArray_type IS
 ARRAY (0 TO 7) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL regArray : regArray_type;
BEGIN
    WriteProcess: PROCESS(Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            IF (Rst = '1') THEN
                regArray(0) <= X"0000" AFTER 6.0 NS;
                regArray(1) <= X"000B" AFTER 6.0 NS;
                regArray(2) <= X"0023" AFTER 6.0 NS;
                regArray(3) <= X"0007" AFTER 6.0 NS;
                regArray(4) <= X"000A" AFTER 6.0 NS;
                regArray(5) <= X"0000" AFTER 6.0 NS;
                regArray(6) <= X"0000" AFTER 6.0 NS;
                regArray(7) <= X"0000" AFTER 6.0 NS;
            ELSE
                IF (W_en = '1') THEN
                    regArray(conv_integer(W_Addr)) <= W_Data AFTER 6.0 NS;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    ReadProcess1: PROCESS(R_en, R_Addr1, regArray)
    BEGIN
        IF (R_en = '1') THEN
            CASE R_Addr1 IS
                WHEN "000" =>
                    Reg_Data1 <= regArray(0) AFTER 6.0 NS;
                WHEN "001" =>
                    Reg_Data1 <= regArray(1) AFTER 6.0 NS;
                WHEN "010" =>
                    Reg_Data1 <= regArray(2) AFTER 6.0 NS;
                WHEN "011" =>
                    Reg_Data1 <= regArray(3) AFTER 6.0 NS;
                WHEN "100" =>
                    Reg_Data1 <= regArray(4) AFTER 6.0 NS;
                WHEN "101" =>
                    Reg_Data1 <= regArray(5) AFTER 6.0 NS;
                WHEN "110" =>
                    Reg_Data1 <= regArray(6) AFTER 6.0 NS;
                WHEN "111" =>
                    Reg_Data1 <= regArray(7) AFTER 6.0 NS;
                WHEN OTHERS =>
                    Reg_Data1 <= (OTHERS=>'0') AFTER 6.0 NS;
            END CASE;
        ELSE
            Reg_Data1 <= (OTHERS=>'0') AFTER 6.0 NS;
        END IF;
    END PROCESS;

    ReadProcess2: PROCESS(R_en, R_Addr2, regArray)
    BEGIN
        IF (R_en = '1') THEN
            CASE R_Addr2 IS
                WHEN "000" =>
                    Reg_Data2 <= regArray(0) AFTER 6.0 NS;
                WHEN "001" =>
                    Reg_Data2 <= regArray(1) AFTER 6.0 NS;
                WHEN "010" =>
                    Reg_Data2 <= regArray(2) AFTER 6.0 NS;
                WHEN "011" =>
                    Reg_Data2 <= regArray(3) AFTER 6.0 NS;
                WHEN "100" =>
                    Reg_Data2 <= regArray(4) AFTER 6.0 NS;
                WHEN "101" =>
                    Reg_Data2 <= regArray(5) AFTER 6.0 NS;
                WHEN "110" =>
                    Reg_Data2 <= regArray(6) AFTER 6.0 NS;
                WHEN "111" =>
                    Reg_Data2 <= regArray(7) AFTER 6.0 NS;
                WHEN OTHERS =>
                    Reg_Data2 <= (OTHERS=>'0') AFTER 6.0 NS;
            END CASE;
        ELSE
            Reg_Data2 <= (OTHERS=>'0') AFTER 6.0 NS;
        END IF;
    END PROCESS;
END Beh;


---------- 16-Bit ALU ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;


ENTITY ALU IS
    PORT (Sel: IN std_logic;
         A: IN std_logic_vector(15 DOWNTO 0);
         B: IN std_logic_vector(15 DOWNTO 0);
         ALU_Out: OUT std_logic_vector (15 DOWNTO 0) );
END ALU;

ARCHITECTURE Beh OF ALU IS

BEGIN
    PROCESS (A, B, Sel)
        variable temp: std_logic_vector(31 DOWNTO 0):= X"00000000";
    BEGIN
        IF (Sel = '0') THEN
            ALU_Out <= A + B AFTER 12 NS;
        ELSIF (Sel = '1') THEN
            temp := A * B ;
            ALU_Out <= temp(15 downto 0) AFTER 12 NS;
        END IF;
    END PROCESS;
END Beh;


---------- 16-bit Shifter ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Shifter IS
    PORT (I: IN std_logic_vector(15 DOWNTO 0);
         Q: OUT std_logic_vector(15 DOWNTO 0);
         sel: IN std_logic );
END Shifter;

ARCHITECTURE Beh OF Shifter IS
BEGIN
    PROCESS (I,sel)
    BEGIN
        IF (sel = '1') THEN
            Q <= I(14 downto 0) & '0' AFTER 4.0 NS;
        ELSE
            Q <= '0' & I(15 downto 1) AFTER 4.0 NS;
        END IF;
    END PROCESS;
END Beh;


---------- 2-to-1 Selector ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Selector IS
    PORT (sel: IN std_logic;
         x,y: IN std_logic_vector(15 DOWNTO 0);
         f: OUT std_logic_vector(15 DOWNTO 0));
END Selector;

ARCHITECTURE Beh OF Selector IS
BEGIN
    PROCESS (x,y,sel)
    BEGIN
        IF (sel = '0') THEN
            f <= x AFTER 3.0 NS;
        ELSE
            f <= y AFTER 3.0 NS;
        END IF;
    END PROCESS;
END Beh;


---------- 16-bit Register ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg IS
    PORT (I: IN std_logic_vector(15 DOWNTO 0);
         Q: OUT std_logic_vector(15 DOWNTO 0);
         Ld: IN std_logic;
         Clk, Rst: IN std_logic );
END Reg;

ARCHITECTURE Beh OF Reg IS
BEGIN
    PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            IF (Rst = '1') THEN
                Q <= X"0000" AFTER 4.0 NS;
            ELSIF (Ld = '1') THEN
                Q <= I AFTER 4.0 NS;
            END IF;
        END IF;
    END PROCESS;
END Beh;

---------- 16-bit Three-state Buffer ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ThreeStateBuff IS
    PORT (Control_Input: IN std_logic;
         Data_Input: IN std_logic_vector(15 DOWNTO 0);
         Output: OUT std_logic_vector(15 DOWNTO 0) );
END ThreeStateBuff;

ARCHITECTURE Beh OF ThreeStateBuff IS
BEGIN
    PROCESS (Control_Input, Data_Input)
    BEGIN
        IF (Control_Input = '1') THEN
            Output <= Data_Input AFTER 2 NS;
        ELSE
            Output <= (OTHERS=>'Z') AFTER 2 NS;
        END IF;
    END PROCESS;
END Beh;

---------- Controller ----------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Controller IS
    PORT(R_en: OUT std_logic;
         W_en: OUT std_logic;
         R_Addr1: OUT std_logic_vector(2 DOWNTO 0);
         R_Addr2: OUT std_logic_vector(2 DOWNTO 0);
         W_Addr: OUT std_logic_vector(2 DOWNTO 0);
         Shifter_Sel: OUT std_logic;
         Selector_Sel: OUT std_logic;
         ALU_sel : OUT std_logic;
         OutReg_Ld: OUT std_logic;
         Oe: OUT std_logic;
         Done: OUT std_logic;
         Start, Clk, Rst: IN std_logic);
END Controller;


ARCHITECTURE Beh OF Controller IS

    TYPE regArray_type IS ARRAY (0 TO 7) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL regArray : regArray_type :=  (X"0000", X"000B", X"0023", X"0007", X"000A", X"0000", X"0000", X"0000");

    -- do not modify any code above this line
    -- additional variables/signals can be declared if needed below
    -- add your code starting here

    TYPE StateType IS ARRAY(3 downto 0) OF std_logic_vector(3 downto 0);
    SIGNAL Currstate, Nextstate: StateType;

BEGIN
    StateReg: PROCESS (Clk)
    BEGIN
        IF (Clk = '1' AND Clk'EVENT) THEN
            IF (Rst = '1') THEN
                Currstate <= "00";
            ELSE
                Currstate <= Nextstate;
            END IF;
        END IF;
    END PROCESS;

    CombLogic: Process (Start, Currstate)
    BEGIN
        case Currstate IS
            When "00" =>
                regArray(5) <= X"00000000"; regArray(6) <= X"00000000"; regArray(7) <= X"00000000";
                if (Start = '1') THEN
                    Nextstate <= "01";
                else
                    Nextstate <= "00";
                end if;
            When "01" =>
                if (Rst = '0') then
                    Nextstate <= "10";
                else
                    Nextstate <= "00";
                end if;
            When "10" =>
                Done <= '1';
                Nextstate <= "00";
            When others =>
                --Do nothing
        end case;
    end Process CombLogic;
END Beh;


---------- Locator (with clock cycle =  ?? NS )----------
--         INDICATE YOUR CLOCK CYCLE TIME ABOVE      ----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Locator_struct is
    Port ( Clk : in  STD_LOGIC;
         Start : in  STD_LOGIC;
         Rst : in  STD_LOGIC;
         Loc : out  STD_LOGIC_VECTOR (15 downto 0);
         Done : out  STD_LOGIC);
end Locator_struct;

architecture Struct of Locator_struct is

    COMPONENT RegFile IS
        PORT (  R_Addr1, R_Addr2, W_Addr: IN std_logic_vector(2 DOWNTO 0);
             R_en, W_en: IN std_logic;
             Reg_Data1: OUT std_logic_vector(15 DOWNTO 0);
             Reg_Data2: OUT std_logic_vector(15 DOWNTO 0);
             W_Data: IN std_logic_vector(15 DOWNTO 0);
             Clk, Rst: IN std_logic );
    END COMPONENT;

    COMPONENT ALU IS
        PORT (Sel: IN std_logic;
             A: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
             B: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
             ALU_Out: OUT STD_LOGIC_VECTOR (15 DOWNTO 0) );
    END COMPONENT;

    COMPONENT Shifter IS
        PORT (I: IN std_logic_vector(15 DOWNTO 0);
             Q: OUT std_logic_vector(15 DOWNTO 0);
             sel: IN std_logic );
    END COMPONENT;

    COMPONENT Selector IS
        PORT (sel: IN std_logic;
             x,y: IN std_logic_vector(15 DOWNTO 0);
             f: OUT std_logic_vector(15 DOWNTO 0) );
    END COMPONENT;

    COMPONENT Reg IS
        PORT (I: IN std_logic_vector(15 DOWNTO 0);
             Q: OUT std_logic_vector(15 DOWNTO 0);
             Ld: IN std_logic;
             Clk, Rst: IN std_logic );
    END COMPONENT;

    COMPONENT ThreeStateBuff IS
        PORT (Control_Input: IN std_logic;
             Data_Input: IN std_logic_vector(15 DOWNTO 0);
             Output: OUT std_logic_vector(15 DOWNTO 0) );
    END COMPONENT;

    COMPONENT Controller IS
        PORT(R_en: OUT std_logic;
             W_en: OUT std_logic;
             R_Addr1: OUT std_logic_vector(2 DOWNTO 0);
             R_Addr2: OUT std_logic_vector(2 DOWNTO 0);
             W_Addr: OUT std_logic_vector(2 DOWNTO 0);
             Shifter_sel: OUT std_logic;
             Selector_sel: OUT std_logic;
             ALU_sel : OUT std_logic;
             OutReg_Ld: OUT std_logic;
             Oe: OUT std_logic;
             Done: OUT std_logic;
             Start, Clk, Rst: IN std_logic);
    END COMPONENT;

    -- do not modify any code above this line
    -- add signals needed below. hint: name them something you can keep track of while debugging/testing
    -- add your code starting here
BEGIN
    StateReg: Reg PORT MAP (Nextstate, Currstate, “1”, Clk, Rst);
    CtrlLogic: PROCESS (Start, Currstate);
    
    Reg_1: 2b-Reg PORT MAP (W1, W2, DP_ld, Clk, Rst);
    Sub_1: 2b-Sub PORT MAP ( W2, “01”, W3););
    Sel2_1: 2b-Sel PORT MAP (W3, “10”, W1);
    Comp_1: 2b-Comp PORT MAP (W3, “00”, DP_Eq); 
    
    regArray(5) <= regArray(2) * regArray(2);
    regArray(6) <= regArray(1) * regArray(5);
    regArray(5) <= "0" & regArray(6)(15 downto 1);
    regArray(6) <= regArray(2) * regArray(3);
    regArray(7) <= regArray(5) + regArray(6);
    regArray(5) <= regArray(7) + regArray(4);
    Output <= regArray(5);

end Struct;

