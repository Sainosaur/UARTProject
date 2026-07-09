LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY toplevel IS
    PORT (
        clk: IN std_logic;
        data: INOUT std_logic_vector(7 DOWNTO 0);
        tx: OUT std_logic;
        rx: IN std_logic;
        error: OUT std_logic
    );
END toplevel;

ARCHITECTURE behavioral of toplevel IS

BEGIN

END behavioral;
