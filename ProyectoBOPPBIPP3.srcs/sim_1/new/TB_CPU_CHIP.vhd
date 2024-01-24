library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TB_CPU_CHIP is
end TB_CPU_CHIP;

architecture Behavioral of TB_CPU_CHIP is
    signal ISTR_PORT_sig : STD_LOGIC := '0';
    signal CLK_sig : STD_LOGIC := '0';
    signal INS_BUS_sig : STD_LOGIC_VECTOR(4 downto 0);
    signal OBUS_PORT_sig : STD_LOGIC_VECTOR(10 downto 0);

    constant CLOCK_PERIOD : time := 50 ns; -- Ajusta según tus necesidades

    -- Declaración del componente
    component CPU_CHIP
        Port ( ISTR_PORT : in STD_LOGIC;
               INS_BUS : out STD_LOGIC_VECTOR (4 downto 0);
               OBUS_PORT : out STD_LOGIC_VECTOR (10 downto 0);
               CLK : in STD_LOGIC);
    end component;

begin
    -- Instancia de la entidad a probar
    DUT: CPU_CHIP
        port map (
            ISTR_PORT => ISTR_PORT_sig,
            INS_BUS => INS_BUS_sig,
            OBUS_PORT => OBUS_PORT_sig,
            CLK => CLK_sig
        );

    -- Proceso para generar el clock
    CLK_process: process
    begin
        while true loop
            CLK_sig <= '0';
            wait for CLOCK_PERIOD / 2;
            CLK_sig <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
    end process;

    -- Proceso para simular la condición inicial
    Initial_condition_process: process
    begin
        ISTR_PORT_sig <= '0';
        wait for 100 ms;
        ISTR_PORT_sig <= '1';
        wait;
    end process;

end Behavioral;