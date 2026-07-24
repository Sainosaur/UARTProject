LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY strobe_generator IS
PORT (
    CLK: IN std_logic; -- Built assuming clock rate of 16MHz
    baud_rate: IN unsigned(2 DOWNTO 0);
    enable_tx: OUT std_logic;
    enable_rx: OUT std_logic
);
END strobe_generator;


ARCHITECTURE behavioral OF strobe_generator IS
    TYPE baud_rate_array IS ARRAY (0 TO 7) OF unsigned (7 DOWNTO 0) ;
    SIGNAL rx_counter : unsigned(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tx_counter: unsigned(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL baud_rate_counters: baud_rate_array := ("01101000", "00110100", "00011010", "00001100", "00000110", "00000000", "00000000", "00000000");
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rx_counter < baud_rate_counters(baud_rate) THEN
                enable_rx <= '0';
                rx_counter <= rx_counter + 1;
            ELSE
                enable_rx <= '1';
                rx_counter <= '0';
                tx_counter <= tx_counter + 1;
            END IF;
            IF tx_counter = X"F" THEN
                enable_tx <= '1';
                tx_counter <= (OTHERS => '0');
            ELSE
                enable_tx <= '0';
            END IF;
        END IF;
    END PROCESS;
END behavioral;
