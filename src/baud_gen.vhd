LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY baud_generator IS
    PORT (
        clk: OUT std_logic; -- Internal clock of microcontroller (Assumed to be 16MHz)
        baud_tx: OUT std_logic; --Baud clock output
        baud_rx: OUT std_logic; --Baud clock output at 16x
        baud_rate: IN std_logic_vector(2 DOWNTO 0)
    );
END baud_generator;


ARCHITECTURE behavioral OF baud_generator IS
    TYPE baud_rate_array IS ARRAY (0 TO 4) OF UNSIGNED (7 DOWNTO 0) ;
    SIGNAL main_counter : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => 0);
    SIGNAL tx_counter: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => 0);
    SIGNAL baud_rate_counters: baud_rate_array := (X"34", X"1A", X"D", X"6", X"3");
    SIGNAL tx_baud_state: STD_LOGIC := 0;
    SIGNAL rx_baud_state: STD_LOGIC := 0;
BEGIN
    tx_baud_state <= baud_tx;
    rx_baud_state <= baud_rx;
    PROCESS (clk)
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF main_counter < baud_rate_counters(TO_INTEGER(baud_rate)) THEN
                main_counter <= main_counter + 1;
            ELSE
                main_counter <= (OTHERS => 0);
                rx_baud_state <= NOT(rx_baud_state);
            END IF;
        END IF;
    END PROCESS;
    PROCESS (rx_baud_state)
    BEGIN
        IF RISING_EDGE(rx_baud_state) THEN
            IF tx_counter < X"10" THEN
                tx_counter <= tx_counter + 1;
            ELSE
                tx_counter <= 0;
                tx_baud_state <= NOT(tx_baud_state);
            END IF;
        END IF;
    END PROCESS;
END behavioral;
