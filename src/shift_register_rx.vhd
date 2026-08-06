LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY shift_register_rx IS
    PORT (
        clk: IN std_logic;
        parallel_mode: IN std_logic; -- if '0' the system shifts through data if '1' the system accepts parallel input and doesn't cycle through data
        strobe_in: IN std_logic;
        shift_in: IN std_logic;
        parallel_data: OUT UNSIGNED(7 DOWNTO 0); -- Reconfigure to IN based on system requirement
        parity: OUT std_logic;
        reset: IN std_logic
    );
END shift_register_rx;


ARCHITECTURE behavioral OF shift_register_rx IS
SIGNAL parallel_data_register : UNSIGNED(7 DOWNTO 0);
BEGIN
parity <= parallel_data_register(7) XOR parallel_data_register(6) XOR parallel_data_register(5) XOR parallel_data_register(4) XOR parallel_data_register(3) XOR parallel_data_register(2) XOR parallel_data_register(1) XOR parallel_data_register(0); -- Calculates parity bit to last register state for FSM to capture
PROCESS(clk)
BEGIN
    IF rising_edge(clk) THEN
        IF reset = '1' THEN
            parallel_data_register <= (OTHERS => '0');
            parallel_data <= (OTHERS => '0');
        ELSE
            CASE parallel_mode IS
                WHEN '1' =>
                    parallel_data <= parallel_data_register; -- Provides parallel data out to main system
                WHEN OTHERS =>
                    IF strobe_in = '1' THEN
                        parallel_data_register <= shift_in & parallel_data_register(7 DOWNTO 1);
                    END IF;
            END CASE;
        END IF;
    END IF;
END PROCESS;
END behavioral;
