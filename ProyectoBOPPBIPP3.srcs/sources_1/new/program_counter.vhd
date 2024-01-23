----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2024 16:04:38
-- Design Name: 
-- Module Name: program_counter - pc_arch
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
    Port ( SET_ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           MOD_PC : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_ADDR : out STD_LOGIC_VECTOR (8 downto 0));
end program_counter;

architecture pc_arch of program_counter is
    signal PC_REG, MUX_OUT: std_logic_vector(8 downto 0) := (others => '0');
begin
    with MOD_PC select
        MUX_OUT <= SET_ADDR when '1',
                   std_logic_vector(unsigned(PC_REG) + 1) when others;
    SYNC: process (CLK)
    begin
        if rising_edge(CLK) then
            if ENABLE = '1' then
                PC_REG <= MUX_OUT;
            end if;
        end if;
    end process;
    
    PC_ADDR <= PC_REG;
end pc_arch;