LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY test_rx_fsm IS
END ENTITY test_rx_fsm;


ARCHITECTURE behavioral OF test_rx_fsm IS
    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL rx_line : STD_LOGIC := '1';
    SIGNAL baud_rate : UNSIGNED(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL parallel_data_recieved: UNSIGNED(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL internal_error_rx : STD_LOGIC;
    SIGNAL transmission_error_rx : STD_LOGIC;
    SIGNAL start_in: STD_LOGIC := '0';
    SIGNAL parallel_data_transmission : UNSIGNED(7 DOWNTO 0);
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL tx : STD_LOGIC;
    SIGNAL strobe: STD_LOGIC;
BEGIN
    fsm_0: ENTITY work.rx_fsm PORT MAP(clk => clk, rx_line => rx_line, baud_rate => baud_rate, parallel_data => parallel_data_recieved, internal_error => internal_error_rx, transmission_error => transmission_error_rx);
    fsm_1: ENTITY work.tx_fsm PORT MAP (clk => clk, start_in => start_in, parallel_data => parallel_data_transmission, reset => reset, strobe => strobe, rx => rx_line, tx => tx, error => OPEN);
    strobe_gen_tx : ENTITY work.strobe_generator_tx PORT MAP (clk => clk, baud_rate => baud_rate, enable_tx => strobe, error => OPEN);

    clk <= NOT clk AFTER 1 ns;
    PROCESS
    BEGIN
        WAIT for 50 ns; -- Ensures both systems exit their INITIAL state into IDLE
        rx_line <= tx; -- Connects rx input of both FSMs with the output of tx FSM
        parallel_data_transmission <= "10101010";
        WAIT FOR 2 ns;
        start_in <= '1';
        WAIT FOR 300 us;
        start_in <= '0';
        WAIT FOR 5 us;

    END PROCESS;

END behavioral;
