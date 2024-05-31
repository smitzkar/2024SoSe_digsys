library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use std.env.finish;

use work.cpu_constants_pkg.REG_LEN;
use work.cpu_constants_pkg.ALU_OP_TYPE;


entity tb_alu is
end entity;


architecture rtl of tb_alu is

    signal clk: std_logic := '0';
    constant CLK_PERIOD: time := 100 ns;
    signal result: std_logic_vector(REG_LEN-1 downto 0);

    signal a_value: std_logic_vector(REG_LEN-1 downto 0);
    signal b_value: std_logic_vector(REG_LEN-1 downto 0);
    signal alu_operation_in: ALU_OP_TYPE;
    signal out_value: std_logic_vector(REG_LEN-1 downto 0);

begin

    uut: entity work.alu
    port map (
        A_VALUE          => a_value,
        B_VALUE          => b_value,
        ALU_OPERATION => alu_operation_in,
        OUT_VALUE        => out_value
    );


    clk_generator: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    test_runner: process
        variable v_a_value : std_logic_vector(REG_LEN-1 downto 0);
        variable v_b_value : std_logic_vector(REG_LEN-1 downto 0);
        variable v_expected: std_logic_vector(REG_LEN-1 downto 0);
        variable v_result  : std_logic_vector(REG_LEN-1 downto 0);

        file fp: text;
        variable row: line;
        variable char: character;
        variable count: integer;
        variable v_alu_op: string(8 downto 1);

    begin
        wait until clk = '0';
        count := 0;
        file_open(fp, "stimuli_alu.txt", READ_MODE);
        while not endfile(fp) loop
            readline(fp, row);
            read(row, v_alu_op);
            read(row, char);
            hread(row, v_a_value);
            read(row, char);
            hread(row, v_b_value);
            read(row, char);
            hread(row, v_expected);
            count := count + 1;

            a_value <= v_a_value;
            b_value <= v_b_value;
            case v_alu_op is
                when "ALU_ADD " => alu_operation_in <= ALU_ADD;
                when "ALU_SUB " => alu_operation_in <= ALU_SUB;
                when "ALU_SLL " => alu_operation_in <= ALU_SLL;
                when "ALU_SLT " => alu_operation_in <= ALU_SLT;
                when "ALU_SLTU" => alu_operation_in <= ALU_SLTU;
                when "ALU_XOR " => alu_operation_in <= ALU_XOR;
                when "ALU_SRA " => alu_operation_in <= ALU_SRA;
                when "ALU_SRL " => alu_operation_in <= ALU_SRL;
                when "ALU_OR  " => alu_operation_in <= ALU_OR;
                when "ALU_AND " => alu_operation_in <= ALU_AND;
                when others =>
                    report "FAIL (" & v_alu_op & "): unknown test";
                    assert false severity failure;
            end case;

            wait for 1 ns;
            if out_value /= v_expected then
                report "FAIL (" & v_alu_op & ", line " &
                    integer'image(count) & "): expected 0x" &
                    to_hstring(v_expected) &
                    ", got 0x" & to_hstring(out_value);
            end if;

            wait for CLK_PERIOD;
        end loop;
        file_close(fp);
        finish;
        wait;
    end process;

end architecture;