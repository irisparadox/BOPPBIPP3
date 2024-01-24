----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2024 23:21:56
-- Design Name: 
-- Module Name: control_unit - cu_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    Port ( OPCODE : in STD_LOGIC_VECTOR (1 downto 0);
           FUNCT : in STD_LOGIC_VECTOR (2 downto 0);
           CONTROL : out STD_LOGIC_VECTOR (7 downto 0));
end control_unit;

architecture cu_arch of control_unit is
    -- Control signals
    -- ALU OP
    -- USE_IMM
    -- LW_MEM
    -- SW_MEM
    -- MOD_PC
    
    signal control_aux: std_logic_vector(7 downto 0) := (others => '0');
    alias ALU_OP: std_logic_vector is control_aux(2 downto 0);
    alias USE_IMM: std_logic is control_aux(3);
    alias WE_WB: std_logic is control_aux(4);
    alias SW_MEM: std_logic is control_aux(5);
    alias MOD_PC: std_logic is control_aux(6);
    alias LW_MEM: std_logic is control_aux(7);
begin
    CONTROL <= control_aux;
    COMB: process(OPCODE, FUNCT)
    begin
        ALU_OP <= "000";
        USE_IMM <= '0';
        WE_WB <= '0';
        SW_MEM <= '0';
        MOD_PC <= '0';
        LW_MEM <= '0';
        case OPCODE is
            when "00" =>
                ALU_OP <= FUNCT;
                WE_WB <= '1';
            when "01" =>
                ALU_OP <= FUNCT;
                USE_IMM <= '1';
                WE_WB <= '1';
            when "10" =>
                case FUNCT is
                    when "000" =>
                        WE_WB <= '1';
                        USE_IMM <= '1';
                    when "001" =>
                        USE_IMM <= '1';
                        MOD_PC <= '1';
                    when "010" =>
                        WE_WB <= '1';
                        LW_MEM <= '1';
                    when "011" =>
                        SW_MEM <= '1';
                    when others =>
                end case;
            when others =>
                USE_IMM <= '0';
                MOD_PC <= '1';                     
        end case;
    end process;
end cu_arch;
