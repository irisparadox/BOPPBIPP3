----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2024 16:45:58
-- Design Name: 
-- Module Name: instruction_rom - im_arch
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

entity instruction_rom is
    Port ( ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           ENABLE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           INS_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end instruction_rom;

architecture im_arch of instruction_rom is
    type reg_bank is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal regs: reg_bank := (others => (others => '0'));
    signal aux : std_logic_vector(31 downto 0) := (others => '0');
begin
    INS_OUT <= aux;
    READ: process (CLK)
    begin 
        if rising_edge(CLK) then
            if ENABLE = '1' then
                aux <= regs(to_integer(unsigned(ADDR)));
            end if;
        end if;
    end process;
    
    -- Program:
    -- 0 : li t0, 10            [0x8034000A]
    -- 1 : li t1, 25            [0x80380019]
    -- 2 : add t2, t0, t1       [0x3C1A0E]
    -- 3 : addi t3, t2, 4       [0x40401E04]
    regs(0) <= "10000000001101000000000000001010";
    regs(1) <= "10000000001110000000000000011001";
    regs(7) <= "00000000001111000001101000001110";
    regs(13) <= "01000000010000000001111000000100";
end im_arch;
