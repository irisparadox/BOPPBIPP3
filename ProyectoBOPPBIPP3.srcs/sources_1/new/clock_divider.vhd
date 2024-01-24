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
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    generic (
        x: std_logic_vector (27 downto 0) := "0101111101011110000100000000"
    );
    port (
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(27 downto 0);
 SIGNAL clk_aux: std_logic;
  
begin

clk_salida<=clk_aux;
  contador:
  PROCESS(clk_entrada)
  BEGIN
    IF(rising_edge(clk_entrada)) THEN
      IF (cuenta = x) THEN 
      	clk_aux <= '1';
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
	    clk_aux<='0';
      END IF;
    END IF;
  END PROCESS contador;

end divisor_arch;