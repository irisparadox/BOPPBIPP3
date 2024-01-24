----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.01.2024 13:31:27
-- Design Name: 
-- Module Name: imm_gen - img_atch
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

entity imm_gen is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (8 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end imm_gen;

architecture img_atch of imm_gen is
    signal aux : std_logic_vector(31 downto 0) := (others => '0');
begin
    DATA_OUT <= std_logic_vector(resize(signed(DATA_IN),32));
end img_atch;
