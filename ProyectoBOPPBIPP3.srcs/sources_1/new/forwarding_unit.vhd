----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2024 18:56:58
-- Design Name: 
-- Module Name: forwarding_unit - fwu_arch
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

entity forwarding_unit is
    generic ( n_bits : integer := 32);
    Port ( DATA_IN : in STD_LOGIC_VECTOR (n_bits - 1 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (n_bits - 1 downto 0);
           ENABLE : in STD_LOGIC;
           CLK : in STD_LOGIC);
end forwarding_unit;

architecture fwu_arch of forwarding_unit is
    signal aux : std_logic_vector (n_bits - 1 downto 0) := (others => '0');
begin
    DATA_OUT <= aux;
    SYNC: process(CLK)
    begin
        if rising_edge(CLK) then
            if ENABLE = '1' then
                aux <= DATA_IN;
            end if;
        end if;
    end process;
end fwu_arch;
