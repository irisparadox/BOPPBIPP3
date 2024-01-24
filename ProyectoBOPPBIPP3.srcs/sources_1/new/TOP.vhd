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
    
    component divisor is
    generic (
        x: std_logic_vector (27 downto 0) := "0101111101011110000100000000"
    );
    port (
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
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

    signal display_0, display_1, display_2, display_3 : STD_LOGIC_VECTOR (6 downto 0);
    signal main_clk : std_logic;
    signal pc : std_logic_vector(15 downto 0) := (others => '0');
    signal start : std_logic;

begin
    
    CPU_CHIP_inst : CPU_CHIP
        port map (
            ISTR_PORT => start,
            PC_OUT_PORT => pc(5 downto 0),
            INS_BUS => INS_BUS,
            OBUS_PORT => OBUS_PORT,
            CLK => main_clk
        );
        
    displays_inst:  displays PORT MAP (
        clk => main_clk,
        digito_0 => pc(3 downto 0),
        digito_1 => pc(7 downto 4),
        digito_2 => pc(11 downto 8),
        digito_3 => pc(15 downto 12),
        display  => display,
        display_enable => s_display
    );

    cd: divisor port map (
        clk_entrada => clk,
        clk_salida => main_clk
    );
    
    db_start: debouncer port map (
        rst => rst,
        clk => main_clk,
        x => START_BUTTON,
        xDeb => open,
        xDebFallingEdge => start,
        xDebRisingEdge => open
    );
    
end top_arch;