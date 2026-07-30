LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY sampler IS
    PORT (
        clk: IN std_logic;
        strobe: IN std_logic;
        resync: IN std_logic;
        rx_in: IN std_logic;
        rx_out: OUT std_logic
    );
END sampler;


ARCHITECTURE behavioral OF sampler IS
    SIGNAL pulse_count : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL zero_count : UNSIGNED (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL one_count : UNSIGNED (2 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF resync = '1' THEN
                pulse_count <= (OTHERS => '0');
                zero_count <= (OTHERS => '0');
            ELSIF strobe = '1' THEN
                pulse_count <= pulse_count + 1;
                IF pulse_count >= X"6" AND pulse_count < X"C" THEN
                    IF rx_in = '0' THEN
                        zero_count <= zero_count + 1;
                    ELSIF rx_in = '1' THEN
                        one_count <= one_count + 1;
                    END IF;
                ELSIF pulse_count = X"F" THEN
                    zero_count <= (OTHERS => '0');
                    one_count <= (OTHERS => '0');
                   IF zero_count > one_count THEN
                        rx_out <= '0';
                    ELSIF one_count > zero_count THEN
                        rx_out <= '1';
                    ELSE
                        rx_out <= 'X';
                   END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END behavioral;
