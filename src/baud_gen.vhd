LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY baud_generator is
    PORT (
        clk: in STD_LOGIC;
        baud_tx: out STD_LOGIC;
        baud_rx: out STD_LOGIC;
        baud_rate: in STD_LOGIC
    )
END baud_generator;


ARCHITECTURE behavioral OF baud_generator IS
SIGNAL
BEGIN


END behavioral;
