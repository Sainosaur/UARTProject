LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY strobe_generator IS
GENERIC (
    strobe_width : integer := 1
);
PORT (
    CLK: IN std_logic;
    baud_rate: IN unsigned(2 DOWNTO 0);
    enable_tx: OUT std_logic;
    enable_rx: OUT std_logic
);
END strobe_generator;


ARCHITECTURE behavioral OF strobe_generator IS
SIGNAL rx_counter : unsigned(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL tx_counter: unsigned(3 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF rx_counter <
        END IF;
    END PROCESS;
END behavioral;
