----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2023 15:27:01
-- Design Name: 
-- Module Name: barrel_shifter - bs_arch
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           DIR: in STD_LOGIC_VECTOR (1 downto 0)
           );
end barrel_shifter;

architecture bs_arch of barrel_shifter is
begin
    process (A, SHAMT, DIR)
    variable shift_amount : integer;
    begin
        shift_amount := to_integer(unsigned(SHAMT));

        case DIR is
            when "00" =>
                B <= A sll shift_amount;
            when "01" =>
                B <= A srl shift_amount;
            when "10" =>
                B <= std_logic_vector(signed(A) sra shift_amount);
            when others =>
                B <= (others => '0');
        end case;
    end process;
end bs_arch;