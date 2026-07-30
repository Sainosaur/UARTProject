LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY test_sampler IS
END test_sampler;


ARCHITECTURE behavioral OF test_sampler IS
    SIGNAL clk : std_logic := '1';
    SIGNAL strobe: std_logic := '0';
    SIGNAL resync : std_logic := '0';
    SIGNAL rx_in : std_logic := '0';
    SIGNAL rx_out : std_logic;
BEGIN
    clk <= NOT clk after 1 ns;
    sampler : ENTITY work.sampler(behavioral) PORT MAP (clk => clk, strobe => strobe, resync => resync, rx_in => rx_in, rx_out => rx_out);
    PROCESS
    BEGIN
        WAIT FOR 20 ns; -- Test case b, ensuring counters do not increment when strobe is LOW
        strobe <= '1';
        WAIT FOR 2 ns;
        resync <= '1'; -- Test case a, ensures system resynchronises when resync is set to '1';
        WAIT FOR 2 ns;
        resync <= '0';
        rx_in <= '1'; -- Test case d, ensures system returns '1' when input is '1'
        WAIT FOR 32 ns;
        rx_in <= '0'; -- Test case e, ensures system returns '0' when input is '0'
        WAIT FOR 50 ns;
        rx_in <= '1'; -- Test case f(I), ensures system returns 'X' when input is ambigioous
        WAIT FOR 14 ns;
        rx_in <= 'X'; -- Test case f(II), esnrues systems returns 'X' when inout is also 'X'
        WAIT FOR 37 ns;
        resync <= '1';
        WAIT FOR 3 ns;

        -- Test case c: feeds the pattern "10101010" one bit per 32 ns sample
        -- window, with noise injected on bits 1, 4 and 7 (2 of the 6 votes
        -- flipped to the opposite value). Majority voting (4 vs 2) should
        -- still resolve rx_out to the correct bit each time.
        resync <= '0';
        rx_in <= '1'; -- bit 1 = '1', noisy
        WAIT FOR 15 ns;
        rx_in <= '0'; -- noise: flips 2 of 6 votes
        WAIT FOR 4 ns;
        rx_in <= '1'; -- noise ends, correct value restored
        WAIT FOR 13 ns;

        rx_in <= '0'; -- bit 2 = '0', clean
        WAIT FOR 32 ns;

        rx_in <= '1'; -- bit 3 = '1', clean
        WAIT FOR 32 ns;

        rx_in <= '0'; -- bit 4 = '0', noisy
        WAIT FOR 15 ns;
        rx_in <= '1'; -- noise: flips 2 of 6 votes
        WAIT FOR 4 ns;
        rx_in <= '0'; -- noise ends, correct value restored
        WAIT FOR 13 ns;

        rx_in <= '1'; -- bit 5 = '1', clean
        WAIT FOR 32 ns;

        rx_in <= '0'; -- bit 6 = '0', clean
        WAIT FOR 32 ns;

        rx_in <= '1'; -- bit 7 = '1', noisy
        WAIT FOR 15 ns;
        rx_in <= '0'; -- noise: flips 2 of 6 votes
        WAIT FOR 4 ns;
        rx_in <= '1'; -- noise ends, correct value restored
        WAIT FOR 13 ns;

        rx_in <= '0'; -- bit 8 = '0', clean
        WAIT FOR 32 ns;

        WAIT;
    END PROCESS;
END behavioral;
