LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY test_strobe_generator_rx IS
END test_strobe_generator_rx;

ARCHITECTURE behavioral OF test_strobe_generator_rx IS
    SIGNAL clk: std_logic := '1';
    SIGNAL baud_rate : UNSIGNED(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL resync : std_logic := '0';
    SIGNAL strobe_sampler : std_logic;
    SIGNAL strobe_fsm : std_logic;
    SIGNAL error : std_logic;
BEGIN
    strobe_gen : ENTITY work.strobe_generator_rx(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, resync => resync, strobe_fsm => strobe_fsm, strobe_sampler => strobe_sampler, error => error);
    clk <= NOT clk AFTER 1 ns;
    PROCESS
    BEGIN
        WAIT FOR 1 us;
        baud_rate <= "001";
        WAIT FOR 7 ns;
        resync <= '1';
        WAIT FOR 2 ns;
        resync <= '0';
        WAIT FOR 1 us;
        baud_rate <= "010";
        WAIT FOR 1 us;
        baud_rate <= "011";
        WAIT FOR 1 us;
        baud_rate <= "100";
        WAIT FOR 1 us;
        baud_rate <= "101";
        WAIT FOR 1 us;
        baud_rate <= "110";
        WAIT FOR 1 us;
        baud_rate <= "111";
        WAIT;
    END PROCESS;
END behavioral;
