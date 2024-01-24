----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2024 18:46:59
-- Design Name: 
-- Module Name: dualr_bank - bank_arch
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

entity dualr_bank is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (31 downto 0);
           BUS_A : out STD_LOGIC_VECTOR (31 downto 0);
           BUS_B : out STD_LOGIC_VECTOR (31 downto 0);
           ADDR_A : in STD_LOGIC_VECTOR (8 downto 0);
           ADDR_B : in STD_LOGIC_VECTOR (8 downto 0);
           WADDR : in STD_LOGIC_VECTOR(8 downto 0);
           WE : in STD_LOGIC;
           CLK: in STD_LOGIC);
end dualr_bank;

architecture bank_arch of dualr_bank is
    
    -- Immutable registers
    -- rz: std_logic_vector(31 downto 0) := (others => '0');
    
    -- General purpose registers
    -- r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12: std_logic_vector(31 downto 0);
    
    -- Temporal registers
    -- t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11: std_logic_vector(31 downto 0);
    
    -- Function parameter registers
    -- a0, a1, a2, a3, a4, a5, a6, a7, a8, a9: std_logic_vector(31 downto 0);
    
    -- Stack pointer
    -- sp: std_logic_vector(31 downto 0);
    
    -- Output signals
    signal reg_outA: std_logic_vector(31 downto 0) := (others => '0');
    signal reg_outB: std_logic_vector(31 downto 0) := (others => '0');
    
    type registerBank is array(35 downto 0) of std_logic_vector(31 downto 0);
    signal regs: registerBank := (others => (others => '0'));
begin
    BUS_A <= regs(to_integer(unsigned(ADDR_A)));
    BUS_B <= regs(to_integer(unsigned(ADDR_B)));
    SYNC: process(CLK)
    begin
        if rising_edge(CLK) then
            if(WE = '1') then
                if(WADDR = "000000000") then
                    regs(to_integer(unsigned(WADDR))) <= (others => '0');
                else
                    regs(to_integer(unsigned(WADDR))) <= DATA_IN;
                end if; 
            end if;
        end if;
    end process;
end bank_arch;