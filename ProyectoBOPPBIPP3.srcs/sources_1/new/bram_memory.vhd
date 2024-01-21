----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2024 17:55:02
-- Design Name: 
-- Module Name: bram_memory - bram_arch
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

entity bram_memory is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (31 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           ADDR : in STD_LOGIC_VECTOR (31 downto 0);
           ENABLE : in STD_LOGIC;
           WE : in STD_LOGIC;
           CLK : in STD_LOGIC);
end bram_memory;

architecture bram_arch of bram_memory is
    type bytes is array(3 downto 0) of std_logic_vector(7 downto 0);
    type memory_blocks is array(2**30 - 1 downto 0) of bytes;
    
    signal memory : memory_blocks := (others => (others => "0"));
    signal b0, b1, b2, b3: std_logic_vector(7 downto 0) := (others => '0');
begin
    SYNC: process (CLK, ENABLE)
    begin
        if ENABLE = '1' then
            if rising_edge(CLK) then
                if WE = '1' then
                    memory(to_integer(unsigned(ADDR(31 downto 2)))) <= (others => DATA_IN);
                else
                    b0 <= memory(to_integer(unsigned(ADDR(31 downto 2))))(to_integer(unsigned(ADDR(1 downto 0))));
                    b1 <= memory(to_integer(unsigned(ADDR(31 downto 2))))(to_integer(unsigned(ADDR(1 downto 0)))+1);
                    b2 <= memory(to_integer(unsigned(ADDR(31 downto 2))))(to_integer(unsigned(ADDR(1 downto 0)))+2);
                    b3 <= memory(to_integer(unsigned(ADDR(31 downto 2))))(to_integer(unsigned(ADDR(1 downto 0)))+3);
                end if;
            end if;
        end if;
    end process;
    
    DATA_OUT <= b3 & b2 & b1 & b0;
end bram_arch;