LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY strobe_generator_tx IS
PORT (
    clk: IN std_logic; -- Built assuming clock rate of 16MHz
    baud_rate: IN unsigned(2 DOWNTO 0);
    enable_tx: OUT std_logic;
    error: OUT std_logic
);
END strobe_generator_tx;


ARCHITECTURE behavioral OF strobe_generator_tx IS
    TYPE baud_rate_array IS ARRAY (0 TO 7) OF unsigned (11 DOWNTO 0) ;
    SIGNAL tx_counter : unsigned(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL baud_rate_counters: baud_rate_array := ("011010000000", "001101000000", "000110100000", "000100000000", "000010000000", "000000000000", "000000000000", "000000000000");
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF baud_rate < 5 THEN
                error <= '0';
                IF tx_counter < baud_rate_counters(TO_INTEGER(baud_rate)) THEN
                    enable_tx <= '0';
                    tx_counter <= tx_counter + 1;
                ELSE
                    enable_tx <= '1';
                    tx_counter <= (OTHERS => '0');
                END IF;
            ELSE
                    error <= '1';
            END IF;
        END IF;
    END PROCESS;
END behavioral;
