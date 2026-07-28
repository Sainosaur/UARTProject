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
    SIGNAL error: std_logic;
    SIGNAL baud_rate: unsigned(2 DOWNTO 0) := (2 => '1', OTHERS => '0');
    SIGNAL rx_strobe : std_logic;
BEGIN
    fsm : ENTITY work.tx_fsm(behavioral) PORT MAP(clk => clk, start_in => start_in, parallel_data => parallel_data, reset => reset, strobe => tx_strobe, rx => rx, tx => tx, error => error);
    strobe_gen : ENTITY work.strobe_generator(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, enable_tx => tx_strobe, enable_rx => rx_strobe, error => error);
    clk <= NOT clk after 1 ns;
    PROCESS
    BEGIN
        WAIT for 1 us;
        parallel_data <= "10101010";
        WAIT for 3 ns;
        parallel_data <= (OTHERS => '0');
        WAIT for 2 ns;
        start_in <= '1';
        WAIT;
    END PROCESS;

END behavioral;
