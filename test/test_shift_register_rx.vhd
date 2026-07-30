LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY test_rx_register IS
END test_rx_register;


ARCHITECTURE behavioral of test_rx_register IS
SIGNAL clk: std_logic := '0';
SIGNAL parallel_mode: std_logic := '0';
SIGNAL strobe_in: std_logic := '1';
SIGNAL shift_in: std_logic := '0';
SIGNAL parallel_data: UNSIGNED (7 DOWNTO 0);
SIGNAL parity: std_logic;
SIGNAL reset : std_logic := '0';
BEGIN
    clk <= NOT clk AFTER 5 ns;
    srt : ENTITY work.shift_register_rx(behavioral) PORT MAP (clk => clk, parallel_mode => parallel_mode, strobe_in => strobe_in, shift_in => shift_in, parallel_data => parallel_data, parity => parity, reset => reset);
    PROCESS
    BEGIN
    strobe_in <= '1';
    WAIT FOR 3 ns;
    shift_in <= '0';
    WAIT FOR 10 ns;
    shift_in <= '1';
    WAIT FOR 10 ns;
    shift_in <= '0';
    WAIT FOR 10 ns;
    shift_in <= '0';
    WAIT FOR 10 ns;
    shift_in <= '0';
    WAIT FOR 10 ns;
    shift_in <= '1';
    WAIT FOR 10 ns;
    shift_in <= '0';
    WAIT FOR 10 ns;
    shift_in <= '1';
    WAIT FOR 10 ns;
    parallel_mode <= '1';
    WAIT FOR 20 ns;
    reset <= '1';
    WAIT;
    END PROCESS;
END behavioral;
