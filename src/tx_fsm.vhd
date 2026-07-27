LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY tx_fsm IS
    PORT(
        clk: IN std_logic;
        start_in: IN std_logic;
        parallel_data: IN unsigned(7 DOWNTO 0);
        reset: IN std_logic;
        strobe: IN std_logic;
        rx: IN std_logic;
        tx: OUT std_logic;
        error: OUT std_logic
    );
END tx_fsm;


ARCHITECTURE behavioral OF tx_fsm IS
TYPE fsm_states IS (INITIAL, IDLE, START, SHIFT, PARITY, STOP);

SIGNAL fsm_state : fsm_states := INITIAL;
SIGNAL initial_counter : unsigned(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL parallel_mode : std_logic := '0';
SIGNAL parity_state : std_logic := '0';
SIGNAL parity_value : std_logic := '0';
SIGNAL reset_state : std_logic := '1';
SIGNAL tx_state : std_logic := '1';
SIGNAL shift_counter : unsigned(2 DOWNTO 0) := (OTHERS => '0');

BEGIN
    shift_register : ENTITY work.shift_register_tx(behavioral) PORT MAP (clk => clk, parallel_mode => parallel_mode, strobe_in => strobe, shift_out => tx_state, parallel_data => parallel_data, parity => parity_state, reset => reset_state);
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset THEN
                fsm_state <= INITIAL;
                initial_counter <= (OTHERS => '0');
                error <= '0';
                reset_state <= '1';
                parallel_mode <= '0';
                tx <= '1'
            ELSIF strobe THEN
                CASE fsm_state IS
                    WHEN INITIAL =>
                        error <= '0';
                        IF initial_counter = X"B" THEN
                            fsm_state <= IDLE;
                            parallel_mode <= '1';
                            reset_state <= '0';
                            tx <= '1';
                        ELSIF rx = '1' THEN
                            initial_counter <= initial_counter + 1;
                        ELSE
                            initial_counter <= (OTHERS => '0');
                            error <= '1';
                        END IF;
                    WHEN IDLE =>
                        IF start_in THEN
                            fsm_state <= START;
                            parallel_mode <= '0';
                            reset_state <= '0';
                            tx <= '1';
                        END IF;
                    WHEN START =>
                        fsm_state <= SHIFT;
                        parity_value <= parity_state;
                        parallel_mode <= '0';
                        reset_state <= '0';
                        tx <= tx_state;
                    WHEN SHIFT =>
                        IF shift_counter = X"7" THEN
                            fsm_state <= PARITY;
                            parallel_mode <= '0';
                            reset_state <= '0';
                            shift_counter <= (OTHERS => '0');
                        ELSE
                            shift_counter <= shift_counter + 1;
                        END IF;
                    WHEN PARITY =>
                        tx <= parity_value;
                        parallel_mode <= '0';
                        reset_state <= '0';
                        fsm_state <= STOP;
                    WHEN STOP =>
                        parallel_mode <= '0';
                        reset_state <= '0';
                        tx <= '1';
                        fsm_state <= IDLE;
                    END CASE;
            END IF;
        END IF;
    END PROCESS;

END behavioral;
