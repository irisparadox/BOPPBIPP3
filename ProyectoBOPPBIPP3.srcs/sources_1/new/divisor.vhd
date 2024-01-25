----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           slow_clk : out STD_LOGIC);
end divisor;

architecture Behavioral of divisor is
    signal counter : integer range 0 to 49999999 := 0; -- Assuming 100MHz clock
    signal slow_clk_temp : STD_LOGIC := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            slow_clk_temp <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                if counter = 49999999 then -- Adjust based on desired frequency
                    counter <= 0;
                    slow_clk_temp <= '1';
                else
                    counter <= counter + 1;
                    slow_clk_temp <= '0';
                end if;
            else
                slow_clk_temp <= '0';
            end if;
        end if;
    end process;

    slow_clk <= slow_clk_temp;

end Behavioral;