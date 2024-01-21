----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2024 18:31:35
-- Design Name: 
-- Module Name: common_reg - reg_arch
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

entity common_reg is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (31 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           ENABLE: in STD_LOGIC;
           WRITE_E : in STD_LOGIC;
           CLK: in STD_LOGIC;
           RST: in STD_LOGIC);
end common_reg;

architecture reg_arch of common_reg is
    signal DATA: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    SYNC: process(CLK,RST,ENABLE)
    begin
        if(ENABLE = '1') then
            if(RST = '1') then
                DATA_OUT <= (others => '0');
            elsif rising_edge(CLK) then
                if(WRITE_E = '1') then
                    DATA <= DATA_IN;
                else
                    DATA_OUT <= DATA;
                end if;
            end if;
        end if;
    end process;
end reg_arch;
