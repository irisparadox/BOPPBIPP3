----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2024 19:08:14
-- Design Name: 
-- Module Name: CPU_CHIP - cpu_arch
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

entity CPU_CHIP is
    Port ( ISTR_PORT : in STD_LOGIC;
           INS_BUS : out STD_LOGIC_VECTOR (4 downto 0);
           OBUS_PORT : out STD_LOGIC_VECTOR (10 downto 0);
           CLK : in STD_LOGIC);
end CPU_CHIP;

architecture cpu_arch of CPU_CHIP is
    -- MAIN COMPONENTS --
    component program_counter is
        Port ( SET_ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           MOD_PC : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_ADDR : out STD_LOGIC_VECTOR (8 downto 0));
    end component;
    
    component instruction_rom is
    Port ( ADDR : in STD_LOGIC_VECTOR (8 downto 0);
           ENABLE : in STD_LOGIC;
           CLK : in STD_LOGIC;
           INS_OUT : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component control_unit is
    Port ( OPCODE : in STD_LOGIC_VECTOR (1 downto 0);
           FUNCT : in STD_LOGIC_VECTOR (2 downto 0);
           CONTROL : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component dualr_bank is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (31 downto 0);
           BUS_A : out STD_LOGIC_VECTOR (31 downto 0);
           BUS_B : out STD_LOGIC_VECTOR (31 downto 0);
           ADDR_A : in STD_LOGIC_VECTOR (8 downto 0);
           ADDR_B : in STD_LOGIC_VECTOR (8 downto 0);
           WADDR : in STD_LOGIC_VECTOR(8 downto 0);
           WE : in STD_LOGIC;
           CLK: in STD_LOGIC);
    end component;
    
    component imm_gen is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (8 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component ALU is
        Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
               B : in STD_LOGIC_VECTOR (31 downto 0);
               OP : in STD_LOGIC_VECTOR (2 downto 0);
               O : out STD_LOGIC_VECTOR (31 downto 0);
               flag_zero : out STD_LOGIC;
               flag_overflow : out STD_LOGIC);
    end component;
    
    component bram_memory is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (31 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (31 downto 0);
           ADDR : in STD_LOGIC_VECTOR (31 downto 0);
           ENABLE : in STD_LOGIC;
           WE : in STD_LOGIC;
           CLK : in STD_LOGIC);
    end component;
    
    -- SEGMENTATION UNITS --
    component forwarding_unit is
    generic ( n_bits : integer := 32);
    Port ( DATA_IN : in STD_LOGIC_VECTOR (n_bits - 1 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (n_bits - 1 downto 0);
           CLK : in STD_LOGIC);
    end component;
    
    -- IF SIGNALS --
    signal PC_OUT : std_logic_vector(8 downto 0) := (others => '0');
    
    signal INS_WORD: std_logic_vector(31 downto 0) := (others => '0');
    
    -- ID SIGNALS --
    signal fwFUNCT_OUT : std_logic_vector(2 downto 0) := (others => '0');
    signal fwOP_OUT : std_logic_vector (1 downto 0) := (others => '0');
    
    signal fwPCIF_OUT : std_logic_vector(8 downto 0) := (others => '0');
    
    signal fwWADDRIF_OUT : std_logic_vector (8 downto 0) := (others => '0');
    
    signal fwADDRA_OUT, fwADDRB_OUT : std_logic_vector(8 downto 0) := (others => '0');
    
    signal fwA_IN, fwB_IN : std_logic_vector (31 downto 0) := (others => '0');
    
    signal fwCONTROLID_OUT : std_logic_vector (7 downto 0) := (others => '0');
    
    signal IMM : std_logic_vector(8 downto 0) := (others => '0');
    
    signal fwIMMGEN : std_logic_vector(31 downto 0) := (others => '0');
    
    -- EX SIGNALS --
    signal fwCONTROLEX_OUT : std_logic_vector (7 downto 0) := (others => '0');
    
    signal fwIMMGEN_OUT : std_logic_vector (31 downto 0) := (others => '0');
    
    signal fwPCEX_OUT : std_logic_vector(8 downto 0) := (others => '0');
    
    signal fwA_OUT, fwB_OUT: std_logic_vector(31 downto 0) := (others => '0');
    
    signal fwALUOUT_IN : std_logic_vector (31 downto 0) := (others => '0');
    
    signal fwFLAGS_IN : std_logic_vector(1 downto 0) := (others => '0');
    
    signal fwWADDRID_OUT : std_logic_vector (8 downto 0) := (others => '0');
    
    -- MEM SIGNALS --
    signal fwCONTROLMEM_OUT : std_logic_vector (7 downto 0) := (others => '0');
    
    signal fwRAMADDR_OUT : std_logic_vector (31 downto 0) := (others => '0');
    
    signal fwALUOUT_OUT: std_logic_vector(31 downto 0) := (others => '0');
    signal fwFLAGS_OUT: std_logic_vector(1 downto 0) := (others => '0');
    
    signal fwWADDREX_OUT : std_logic_vector (8 downto 0) := (others => '0');
    
    signal fwMEMORYOUT_IN : std_logic_vector(31 downto 0) := (others => '0');
    
    signal fwWADDRMEM_OUT : std_logic_vector (8 downto 0) := (others => '0');
    
    -- WB SIGNALS --
    signal fwMEMORYOUT_OUT, fwALUWB_OUT : std_logic_vector(31 downto 0) := (others => '0');
    signal fwCONTROLWB_OUT : std_logic_vector(7 downto 0) := (others => '0');
    
    signal fwWADDR_OUT: std_logic_vector(8 downto 0) := (others => '0');
    
    -- MUXES --
    signal A_ALU, B_ALU : std_logic_vector (31 downto 0) := (others => '0');
    
    signal DATA_OUT: std_logic_vector(31 downto 0) := (others => '0');
begin
    INS_BUS <= INS_WORD(31 downto 27);
    OBUS_PORT <= DATA_OUT(10 downto 0);

    -- IF --
    
    pc: program_counter
    Port map (
        SET_ADDR => fwALUOUT_OUT(8 downto 0),
        MOD_PC => fwCONTROLMEM_OUT(6),
        ENABLE => ISTR_PORT,
        CLK => CLK,
        PC_ADDR => PC_OUT
    );
    
    ir: instruction_rom
    Port map (
        ADDR => PC_OUT,
        ENABLE => ISTR_PORT,
        CLK => CLK,
        INS_OUT => INS_WORD
    );
    
    -- FORWARD INSTRUCTION WORD --
    fwOP: forwarding_unit
    generic map ( n_bits => 2 )
    Port map (
        DATA_IN => INS_WORD(31 downto 30),
        DATA_OUT => fwOP_OUT,
        CLK => CLK
    );
    
    fwFUNCT: forwarding_unit
    generic map ( n_bits => 3 )
    Port map (
        DATA_IN => INS_WORD(29 downto 27),
        DATA_OUT => fwFUNCT_OUT,
        CLK => CLK
    );
    
    fwPC: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => PC_OUT,
        DATA_OUT => fwPCIF_OUT,
        CLK => CLK
    );
    
    fwADDRA: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => INS_WORD(17 downto 9),
        DATA_OUT => fwADDRA_OUT,
        CLK => CLK
    );
    
    fwADDRB: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => INS_WORD(8 downto 0),
        DATA_OUT => fwADDRB_OUT,
        CLK => CLK
    );
    
    fwIMM: forwarding_unit
    generic map (n_bits => 9)
    Port map (
        DATA_IN => INS_WORD(8 downto 0),
        DATA_OUT => IMM,
        CLK => CLK
    );
    
    fwWADDRIF: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => INS_WORD(26 downto 18),
        DATA_OUT => fwWADDRIF_OUT,
        CLK => CLK
    );

    -- ID --
    
    cu: control_unit
    Port map (
        OPCODE => fwOP_OUT,
        FUNCT => fwFUNCT_OUT,
        CONTROL => fwCONTROLID_OUT
    );

    regs: dualr_bank
    Port map(
        DATA_IN => DATA_OUT,
        BUS_A => fwA_IN,
        BUS_B => fwB_IN,
        ADDR_A => fwADDRA_OUT,
        ADDR_B => fwADDRB_OUT,
        WADDR => fwWADDR_OUT,
        WE => fwCONTROLWB_OUT(4), 
        CLK => CLK
    );
    
    immgen: imm_gen
    Port map (
        DATA_IN => IMM,
        DATA_OUT => fwIMMGEN
    );
    
    -- FORWARD CONTROL UNIT --
    fwCU_CONTROL: forwarding_unit
    generic map ( n_bits => 8 )
    Port map (
        DATA_IN => fwCONTROLID_OUT,
        DATA_OUT => fwCONTROLEX_OUT,
        CLK => CLK
    );
    
    -- FORWARD REGS --
    fwREGSA: forwarding_unit
    generic map ( n_bits => 32 )
    Port map (
        DATA_IN => fwA_IN,
        DATA_OUT => fwA_OUT,
        CLK => CLK
    );
    
    fwREGSB: forwarding_unit
    generic map ( n_bits => 32 )
    Port map (
        DATA_IN => fwB_IN,
        DATA_OUT => fwB_OUT,
        CLK => CLK
    );
    
    -- FORWARD WRITEBACK ADDRESS --
    fwWADDRID: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => fwWADDRIF_OUT,
        DATA_OUT => fwWADDRID_OUT,
        CLK => CLK
    );
    
    -- FORWARD IMMEDIATE GENERATOR --
    fwIMMGENERATOR: forwarding_unit
    generic map ( n_bits => 32 )
    Port map (
        DATA_IN => fwIMMGEN,
        DATA_OUT => fwIMMGEN_OUT,
        CLK => CLK
    );
    
    -- ID --
    
    -- EX --
    
    with fwCONTROLEX_OUT(6) select
        A_ALU <= fwA_OUT when '0',
                 std_logic_vector(resize(unsigned(fwPCEX_OUT), 32)) when others;
    
    with fwCONTROLEX_OUT(3) select
        B_ALU <= fwB_OUT when '0',
                 fwIMMGEN_OUT when others;

    core: ALU
    Port map (
        A => A_ALU,
        B => B_ALU,
        OP => fwCONTROLEX_OUT(2 downto 0),
        O => fwALUOUT_IN,
        flag_zero => fwFLAGS_IN(0),
        flag_overflow => fwFLAGS_IN(1)
    );
    
    -- FORWARD CONTROL UNIT --
    fwCUEX: forwarding_unit
    generic map (n_bits => 8)
    Port map (
        DATA_IN => fwCONTROLEX_OUT,
        DATA_OUT => fwCONTROLMEM_OUT,
        CLK => CLK
    );
    
    -- FORWARD ALU OUTPUT --
    fwALUO: forwarding_unit
    generic map ( n_bits => 32 )
    Port map (
        DATA_IN => fwALUOUT_IN,
        DATA_OUT => fwALUOUT_OUT,
        CLK => CLK
    );
    
    fwALUFLAGS: forwarding_unit
    generic map ( n_bits => 2 )
    Port map (
        DATA_IN => fwFLAGS_IN,
        DATA_OUT => fwFLAGS_OUT,
        CLK => CLK
    );
    
    fwBOUT: forwarding_unit
    generic map ( n_bits => 32)
    Port map (
        DATA_IN => fwB_OUT,
        DATA_OUT => fwRAMADDR_OUT,
        CLK => CLK
    );
    
    -- FORWARD WRITEBACK ADDRESS --
    fwWADDREX: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => fwWADDRID_OUT,
        DATA_OUT => fwWADDREX_OUT,
        CLK => CLK
    );
    
    -- EX --
    
    -- MEM --
    
    ram: bram_memory
    Port map (
        DATA_IN => fwALUOUT_OUT,
        DATA_OUT => fwMEMORYOUT_IN,
        ADDR => fwRAMADDR_OUT,
        ENABLE => ISTR_PORT,
        WE => fwCONTROLMEM_OUT(5),
        CLK => CLK
    );
    
    fwMEM: forwarding_unit
    generic map (n_bits => 32)
    Port map (
        DATA_IN => fwMEMORYOUT_IN,
        DATA_OUT => fwMEMORYOUT_OUT,
        CLK => CLK
    );
    
    fwCONTROLMEM: forwarding_unit
    generic map (n_bits => 8)
    Port map (
        DATA_IN => fwCONTROLMEM_OUT,
        DATA_OUT => fwCONTROLWB_OUT,
        CLK => CLK
    );
    
    fwALUMEM: forwarding_unit
    generic map (n_bits => 32)
    Port map (
        DATA_IN => fwALUOUT_OUT,
        DATA_OUT => fwALUWB_OUT,
        CLK => CLK
    );
    
    -- FORWARD WRITEBACK ADDRESS --
    fwWADDRMEM: forwarding_unit
    generic map ( n_bits => 9 )
    Port map (
        DATA_IN => fwWADDREX_OUT,
        DATA_OUT => fwWADDR_OUT,
        CLK => CLK
    );
    
    -- MEM --
    
    -- WB --
    with fwCONTROLWB_OUT(7) select
        DATA_OUT <= fwMEMORYOUT_OUT when '1',
                    fwALUWB_OUT when others;

end cpu_arch;
