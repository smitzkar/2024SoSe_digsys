library ieee;
use ieee.std_logic_1164.all;

use work.cpu_constants_pkg.INSTRUCTION_TYPE;
use work.cpu_constants_pkg.DATA_TYPE;

entity IMMEDIATE_EXT is
    port(
        INSTRUCTION_IN : in INSTRUCTION_TYPE;
        IMMEDIATE :out DATA_TYPE
    );
end entity IMMEDIATE_EXT;

architecture ARCH of IMMEDIATE_EXT is

begin
    imm_gen_p: process(INSTRUCTION_IN)
    begin
        case (INSTRUCTION_IN(6 downto 0)) is
            when "0100011" => -- S-Type STORE
                IMMEDIATE <= (31 downto 12 => INSTRUCTION_IN(31)) & INSTRUCTION_IN(31 downto 25) & INSTRUCTION_IN(11 downto 7);
            --TODO...    
            when others =>
                IMMEDIATE <= (others => '0');
        end case;
    end process imm_gen_p;

end architecture ARCH;