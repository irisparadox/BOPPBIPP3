----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2023 14:07:52
-- Design Name: 
-- Module Name: adder_sub - addsub_arch
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
use IEEE.STD_LOGIC_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_sub is
    Port ( OP: in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           O : out STD_LOGIC_VECTOR (31 downto 0);
           Cout : out STD_LOGIC);
end adder_sub;

architecture addsub_arch of adder_sub is
    signal tempOut: STD_LOGIC_VECTOR(32 downto 0) := (others => '0');
    signal B_Signal: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Cin_Signal: STD_LOGIC := '0';
begin
    -- Negative 1s complement of B when sub signal is activated on ALU
    with OP select
        B_Signal <= not(B) when '1',
                    B when others;
    -- We assign to the Cin the OP signal (0 when add, 1 when sub)
    -- This way we convert from 1s complement to 2s complement
    Cin_Signal <= OP;
                   
    process(A,B_Signal,Cin_Signal)
    begin
        tempOut <= (A(31) & A) + (B_Signal(31) & B_Signal) + Cin_Signal;
    end process;
    
    O <= tempOut(31 downto 0);
    Cout <= tempOut(32);
end addsub_arch;
