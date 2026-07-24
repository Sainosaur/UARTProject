LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY test_strobe_gen IS
END test_strobe_gen;


ARCHITECTURE behavioral OF test_strobe_gen IS
    SIGNAL clk : std_logic := '0';
    SIGNAL baud_rate: unsigned(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL enable_tx: std_logic;
    SIGNAL enable_rx: std_logic;
    SIGNAL error: std_logic;
BEGIN
    clk <= NOT clk after 1 ns; -- Inflated clock rate to allow for faster simulation
    strobe_gen : ENTITY work.strobe_generator(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, enable_tx => enable_tx, enable_rx => enable_rx, error => error);
    PROCESS
    BEGIN
        --Running system on 9600 baud
        WAIT FOR 10 us;
        baud_rate <= "001"; -- Running system on 19200 baud
        WAIT FOR 10 us;
        baud_rate <= "010"; -- Running system on 38400 baud
        WAIT FOR 10 us;
        baud_rate <= "011"; -- Running system on 57600 baud
        WAIT FOR 10 us;
        baud_rate <= "100"; -- Running system on 115200 baud
        WAIT FOR 10 us;
        baud_rate <= "101"; -- Setting system to illegal baud_rate settings
        WAIT FOR 10 us;
        baud_rate <= "110";
        WAIT FOR 10 us;
        baud_rate <= "111";
        WAIT;
    END PROCESS;
END behavioral;
