----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.01.2024 17:26:44
-- Design Name: 
-- Module Name: ALU - alu_arch
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           OP : in STD_LOGIC_VECTOR (2 downto 0);
           O : out STD_LOGIC_VECTOR (31 downto 0);
           flag_zero : out STD_LOGIC;
           flag_overflow : out STD_LOGIC);
end ALU;

architecture alu_arch of ALU is
    component adder_sub is
    Port ( OP: in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           O : out STD_LOGIC_VECTOR (31 downto 0);
           Cout : out STD_LOGIC
         );
    end component;
    
    component barrel_shifter is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : out STD_LOGIC_VECTOR (31 downto 0);
           SHAMT : in STD_LOGIC_VECTOR (4 downto 0);
           DIR: in STD_LOGIC_VECTOR (1 downto 0)
         );
    end component;
    
    -- Control signals
    signal sub_enable: std_logic := '0';
    signal shift_direction: std_logic_vector(1 downto 0) := (others => '0');
    constant zero: std_logic_vector(31 downto 0) := (others => '0');
    
    -- Output signals
    signal adder_sub_out: std_logic_vector(31 downto 0) := (others => '0');
    signal shifter_out: std_logic_vector(31 downto 0) := (others => '0');
    signal mux_out: std_logic_vector(31 downto 0) := (others => '0');
    
    -- Arith signals
    signal a_XOR_b, a_OR_b, a_AND_b: std_logic_vector(31 downto 0) := (others => '0');
begin
    a_XOR_b <= A XOR B;
    a_OR_b <= A OR B;
    a_AND_b <= A AND B;
    
    coreadder: adder_sub
    Port map (
        OP => sub_enable,
        A => A,
        B => B,
        O => adder_sub_out,
        Cout => flag_overflow
    );
    
    coreshifter: barrel_shifter
    Port map (
        A => A,
        B => shifter_out,
        SHAMT => B(4 downto 0),
        DIR => shift_direction
    );
    
    with OP select
        mux_out <= adder_sub_out when "000" | "001",
                   a_XOR_b when "010",
                   a_OR_b when "011",
                   a_AND_b when "100",
                   shifter_out when others;
    with OP select
        shift_direction <= "00" when "101",
                            "01" when "110",
                            "10" when others;
                   
    with adder_sub_out select
        flag_zero <= '1' when zero,
                     '0' when others;
                     
    O <= mux_out;
end alu_arch;
