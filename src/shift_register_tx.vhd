LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY shift_register_tx IS
    PORT (
        clk: IN std_logic; -- Clock input
        parallel_mode: IN std_logic; -- if '0' the system shifts through data if '1' the system accepts parallel input and doesn't cycle through data
        strobe_in: IN std_logic; -- Clock enable / strobe input, register will only shift if high
        shift_out: OUT std_logic; -- Output of register
        parallel_data: IN UNSIGNED(7 DOWNTO 0); -- Reconfigure to OUT based on system requirement
        parity: OUT std_logic; -- Live parity bit output of whatever the register currently holds
        reset: IN std_logic -- Bit used to reset entire register, if '1' system wipes current state.
    );
END shift_register_tx;


ARCHITECTURE behavioral OF shift_register_tx IS
SIGNAL parallel_data_register : UNSIGNED(7 DOWNTO 0);
BEGIN
parity <= parallel_data_register(7) XOR parallel_data_register(6) XOR parallel_data_register(5) XOR parallel_data_register(4) XOR parallel_data_register(3) XOR parallel_data_register(2) XOR parallel_data_register(1) XOR parallel_data_register(0); -- Calculates parity bit to last register state for FSM to capture
shift_out <= parallel_data_register(7);
PROCESS(clk)
BEGIN
    IF rising_edge(clk) THEN
        IF reset = '1' THEN
            parallel_data_register <= (OTHERS => '0');
        ELSE
            CASE parallel_mode IS
                WHEN '1' =>
                    parallel_data_register <= parallel_data; -- Accepts parallel data into internal system register
                WHEN OTHERS =>
                    IF strobe_in = '1' THEN
                        parallel_data_register <= parallel_data_register(6 DOWNTO 0) & '0';
                    END IF;
            END CASE;
        END IF;
    END IF;
END PROCESS;
END behavioral;
