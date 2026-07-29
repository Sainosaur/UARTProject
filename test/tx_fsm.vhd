LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY test_tx_fsm IS
END test_tx_fsm;


ARCHITECTURE behavioral of test_tx_fsm IS
    SIGNAL clk : std_logic := '1';
    SIGNAL start_in: std_logic := '0';
    SIGNAL parallel_data : unsigned(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reset: std_logic := '0';
    SIGNAL tx_strobe: std_logic := '0';
    SIGNAL rx : std_logic := '0';
    SIGNAL tx : std_logic;
    SIGNAL fsm_error: std_logic;
    SIGNAL strobe_error: std_logic;
    SIGNAL baud_rate: unsigned(2 DOWNTO 0) := (2 => '1', OTHERS => '0');
    SIGNAL rx_strobe : std_logic;
BEGIN
    fsm : ENTITY work.tx_fsm(behavioral) PORT MAP(clk => clk, start_in => start_in, parallel_data => parallel_data, reset => reset, strobe => tx_strobe, rx => rx, tx => tx, error => fsm_error);
    strobe_gen : ENTITY work.strobe_generator(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, enable_tx => tx_strobe, enable_rx => rx_strobe, error => strobe_error);
    clk <= NOT clk after 1 ns;
    PROCESS
    BEGIN
        WAIT for 5 us; -- Ensures system raises error flag when rx is not '1'
        rx <= '1'; -- Allows system to move out of INITIAL state
        -- Test Case 1 (Expected parity bit = '0')
        parallel_data <= "10101010";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 2 (Expected parity bit = '0')
        parallel_data <= "01010101";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 3 (Expected parity bit = '0')
        parallel_data <= "00000000";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 4 (Expected parity bit = '0')
        parallel_data <= "11111111";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 5 (Expected parity bit = '1')
        parallel_data <= "00000001";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 6 (Expected parity bit = '1')
        parallel_data <= "10000000";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 7 (Expected parity bit = '0')
        parallel_data <= "11001100";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 8 (Expected parity bit = '0')
        parallel_data <= "00110011";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 9 (Expected parity bit = '0')
        parallel_data <= "01101001";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

        -- Test Case 10 (Expected parity bit = '0')
        parallel_data <= "11100010";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;
        WAIT;
    END PROCESS;

END behavioral;
