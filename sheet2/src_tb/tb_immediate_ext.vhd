library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.finish;

use work.cpu_constants_pkg.INSTRUCTION_TYPE;
use work.cpu_constants_pkg.DATA_TYPE;


entity tb_immediate_ext is
end entity;


architecture rtl of tb_immediate_ext is

    signal instruction_in: INSTRUCTION_TYPE;
    signal immediate: DATA_TYPE;
    signal test_line: integer := 0;

begin

    uut: entity work.immediate_ext
    port map (
        INSTRUCTION_IN => instruction_in,
        IMMEDIATE      => immediate
    );


    test_runner: process

        file fp: text;
        variable row: line;
        variable char: character;
        variable count: integer;

        variable v_instruction_in: INSTRUCTION_TYPE;
        variable v_immediate: DATA_TYPE;

    begin
        count := 0;
        file_open(fp, "stimuli_imm.txt", READ_MODE);
        readline(fp, row);
        while not endfile(fp) loop
            readline(fp, row);
            hread(row, v_instruction_in);
            read(row, char);
            hread(row, v_immediate);
            count := count + 1;
            instruction_in <= v_instruction_in;
            test_line <= count;
            wait for 1 ns;
            if immediate /= v_immediate then
                report "FAIL (immediate, line "  &
                    integer'image(count) & "): expected 0x" &
                    to_hstring(v_immediate) &
                    ", got 0x" & to_hstring(immediate);
            end if;
        end loop;
        wait for 1 ns;
        file_close(fp);
        finish;
        wait;
    end process;

end architecture;