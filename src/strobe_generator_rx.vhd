LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY strobe_generator_rx IS
    PORT (
        clk: IN std_logic;
        baud_rate: IN UNSIGNED(2 DOWNTO 0);
        resync: IN std_logic;
        strobe_sampler: OUT std_logic;
        strobe_fsm: OUT std_logic;
        error: OUT std_logic
    );
END strobe_generator_rx;



ARCHITECTURE behavioral OF strobe_generator_rx IS
TYPE baud_rate_array IS ARRAY (0 TO 7) OF unsigned (7 DOWNTO 0) ;
SIGNAL rx_counter : unsigned(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL fsm_counter : unsigned(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL baud_rate_counters: baud_rate_array := ("01101000", "00110100", "00011010", "00010000", "00001000", "00000000", "00000000", "00000000");
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF baud_rate < 5 THEN
                error <= '0';
                IF resync = '1' THEN
                    rx_counter <= (OTHERS => '0');
                    fsm_counter <= (OTHERS => '0');
                ELSIF rx_counter < baud_rate_counters(TO_INTEGER(baud_rate)) THEN
                    strobe_sampler <= '0';
                    rx_counter <= rx_counter + 1;
                ELSE
                    strobe_sampler <= '1';
                    rx_counter <= (OTHERS => '0');
                    fsm_counter <= fsm_counter + 1;
                END IF;
                IF fsm_counter = X"F" THEN
                    strobe_fsm <= '1';
                    fsm_counter <= (OTHERS => '0');
                ELSE
                    strobe_fsm <= '0';
                END IF;
            ELSE
                error <= '1';
            END IF;
        END IF;
    END PROCESS;
END behavioral;
