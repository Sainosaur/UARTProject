LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY test_tx_register IS
END test_tx_register;


ARCHITECTURE behavioral of test_tx_register IS
SIGNAL clk: std_logic := '0';
SIGNAL parallel_mode: std_logic := '0';
SIGNAL strobe_in: std_logic := '1';
SIGNAL shift_out: std_logic;
SIGNAL parallel_data: UNSIGNED (7 DOWNTO 0) := (OTHERS => '0');
SIGNAL parity: std_logic := '0';
SIGNAL reset: std_logic := '0';

BEGIN
    clk <= NOT clk AFTER 5 ns;
    srt : ENTITY work.shift_register_tx(behavioral) PORT MAP (clk => clk, parallel_mode => parallel_mode, strobe_in => strobe_in, shift_out => shift_out, parallel_data => parallel_data, parity => parity, reset => reset);
    PROCESS
    BEGIN
    parallel_mode <= '1';
    parallel_data <= "10101010";
    WAIT FOR 7 ns;
    parallel_mode <= '0';
    WAIT FOR 15 ns;
    strobe_in <= '0';
    WAIT FOR 50 ns;
    strobe_in <= '1';
    WAIT for 100 ns;
    parallel_mode <= '1';
    parallel_data <= "11111111";
    WAIT FOR 10 ns;
    parallel_mode <= '0';
    WAIT FOR 10 ns;
    reset <= '1';
    WAIT;
    END PROCESS;
END behavioral;
