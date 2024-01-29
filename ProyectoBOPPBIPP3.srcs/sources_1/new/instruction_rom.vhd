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
    Port ( ADDR : in STD_LOGIC_VECTOR (5 downto 0);
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
                aux <= regs(to_integer(unsigned(ADDR(5 downto 0))));
            end if;
        end if;
    end process;
    
    -- Program:
    -- 0 : li t0, 10            [0x8034000A]
    -- 1 : li t1, 25            [0x80380019]
    -- 2 : add t2, t0, t1       [0x003C1A0E]
    -- 3 : addi t3, t2, 4       [0x40401E04]
    -- 4 : sw t3, zero          [0x98002000]
    -- 5 : lw t4, zero          [0x90440000]
    -- 6 : li sp, 63            [0x807C001F]
    -- 7 : addi sp, sp, -4      [0x407C01FC]
    -- 8 : li r1, 4             [0x80040002]
    -- 9 : sw r1, sp            [0x9800041F]
    -- 10 : addi r1, t4, -16    [0x404423F0]
    -- 11 : lw t3, sp           [0x90403E00]
    -- 12 : sw r1, t3           [0x98000210]
    -- 13 : addi sp, sp, 4      [0x407C3E00]
    -- 14 : slli t4, t4, 4      [0x60442204]
    -- 15 : aipc -2             [0x880001FF]
    regs(0)  <= "10000000001101000000000000001010"; -- 0
    regs(1)  <= "10000000001110000000000000011001"; -- 1
    regs(7)  <= "00000000001111000001101000001110"; -- 2
    regs(13) <= "01000000010000000001111000000100"; -- 3
    regs(18) <= "10011000000000000010000000000000"; -- 4
    regs(20) <= "10010000010001000000000000000000"; -- 5
    regs(26) <= "10000000011111000000000000111111"; -- 6
    regs(31) <= "01000000011111000011111111111100"; -- 7
    regs(32) <= "10000000000001000000000000000100"; -- 8
    regs(38) <= "10011000000000000000001000011111"; -- 9
    regs(44) <= "01000000000001000010001111110000"; -- 10
    regs(47) <= "10010000010000000000000000011111"; -- 11
    regs(53) <= "10011000000000000000001000010000"; -- 12
    regs(54) <= "01000000011111000011111000000100"; -- 13
    regs(55) <= "01101000010001000010001000000100"; -- 14
    regs(56) <= "10001000000000000000000111111110"; -- 15
end im_arch;
