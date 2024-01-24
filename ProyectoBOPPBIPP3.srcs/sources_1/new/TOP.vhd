----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2024 17:00:31
-- Design Name: 
-- Module Name: TOP - top_arch
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

entity TOP is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           START_BUTTON : in STD_LOGIC;
           display : out STD_LOGIC_VECTOR (6 downto 0);
           s_display : out STD_LOGIC_VECTOR (3 downto 0);
           OBUS_PORT : out STD_LOGIC_VECTOR (10 downto 0);
           INS_BUS : out STD_LOGIC_VECTOR (4 downto 0));
end TOP;

architecture top_arch of TOP is
    component CPU_CHIP is
        Port ( ISTR_PORT : in STD_LOGIC;
               PC_OUT_PORT : out STD_LOGIC_VECTOR (5 downto 0);
               INS_BUS : out STD_LOGIC_VECTOR (4 downto 0);
               OBUS_PORT : out STD_LOGIC_VECTOR (10 downto 0);
               CLK : in STD_LOGIC);
    end component;
    
    component displays is
    Port ( 
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
     );
    end component;
    
    COMPONENT debouncer
    PORT (
      rst: IN std_logic;
      clk: IN std_logic;
      x: IN std_logic;
      xDeb: OUT std_logic;
      xDebFallingEdge: OUT std_logic;
      xDebRisingEdge: OUT std_logic
    );
    END COMPONENT;
    
    component divisor is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               start : in STD_LOGIC;
               slow_clk : out STD_LOGIC);
    end component;

    signal display_0, display_1, display_2, display_3 : STD_LOGIC_VECTOR (6 downto 0);
    signal pc : std_logic_vector(15 downto 0) := (others => '0');
    signal start : std_logic;
    signal reset_n : std_logic;
    signal enable_1hz : STD_LOGIC;

begin
    reset_n <= not(rst);
    CPU_CHIP_inst : CPU_CHIP
        port map (
            ISTR_PORT => enable_1hz,
            PC_OUT_PORT => pc(5 downto 0),
            INS_BUS => INS_BUS,
            OBUS_PORT => OBUS_PORT,
            CLK => clk
        );
        
    displays_inst:  displays PORT MAP (
        clk => clk,
        digito_0 => pc(3 downto 0),
        digito_1 => pc(7 downto 4),
        digito_2 => pc(11 downto 8),
        digito_3 => pc(15 downto 12),
        display  => display,
        display_enable => s_display
    );
    
    db_start: debouncer port map (
        rst => reset_n,
        clk => clk,
        x => START_BUTTON,
        xDeb => start,
        xDebFallingEdge => open,
        xDebRisingEdge => open
    );
    
    clk_divider_inst: divisor port map (
        clk => clk,
        rst => rst,
        start => start,
        slow_clk => enable_1hz
    );
    
end top_arch;