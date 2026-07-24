LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY strobe_gen_tb IS
END strobe_gen_tb;


ARCHITECTURE behavioral OF strobe_gen_tb IS
    SIGNAL clk : std_logic := '0';
    SIGNAL baud_rate: unsigned : (OTHERS => '0');
    SIGNAL enable_tx: std_logic;
    SIGNAL enable_rx: std_logic;
BEGIN
    clk <= NOT clk after 32.25 ns;
    strobe_gen : ENTITY work.strobe_generator(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, enable_tx => enable_tx, enable_rx => enable_rx);
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
        baud_rate <= "100" -- Running system on 115200 baud
        WAIT FOR 10 us;
        baud_rate <= "101" -- Setting system to illegal baud_rate settings
        WAIT FOR 10 us;
        baud_rate <= "110"
        WAIT FOR 10 us;
        baud_rate <= "111"
        WAIT;
    END PROCESS;
END behavioral;
