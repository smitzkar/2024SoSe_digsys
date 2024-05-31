library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.cpu_constants_pkg.all;

entity ALU is
port (
    A_VALUE         : in  DATA_TYPE;
    B_VALUE         : in  DATA_TYPE;
    ALU_OPERATION   : in  ALU_OP_TYPE;
    OUT_VALUE       : out DATA_TYPE
);
end entity ALU;



architecture ARCH of ALU is

    signal out_value_s : DATA_TYPE;

begin

    ALU_P: process(A_VALUE, B_VALUE, ALU_OPERATION)
    begin

        case ALU_OPERATION is
            when  ALU_OR   =>
                out_value_s <= A_VALUE or B_VALUE;
            --TODO
            when others =>
                null;

        end case;
    end process ALU_P;

    OUT_VALUE <= out_value_s;
end architecture ARCH;