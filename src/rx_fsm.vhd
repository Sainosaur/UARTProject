LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY rx_fsm IS
PORT (
    clk : IN STD_LOGIC;
    rx_line : IN STD_LOGIC;
    baud_rate: IN UNSIGNED(2 DOWNTO 0);
    parallel_data : OUT UNSIGNED(7 DOWNTO 0);
    internal_error : OUT STD_LOGIC;
    transmission_error: OUT STD_LOGIC
);
END ENTITY rx_fsm;


ARCHITECTURE behavioral OF rx_fsm IS
TYPE fsm_states IS (INITIAL, IDLE, START, SHIFT, PARITY, STOP);

SIGNAL fsm_state : fsm_states := INITIAL;
SIGNAL initial_counter : unsigned(3 DOWNTO 0) := (OTHERS => '0');
SIGNAL parallel_mode : std_logic := '0';
SIGNAL parity_state : std_logic := '0';
SIGNAL parity_calculated: STD_LOGIC;
SIGNAL resync_state : std_logic := '0';
SIGNAL reset_state : std_logic := '0';
SIGNAL rx_state : STD_LOGIC;
SIGNAL shift_counter : unsigned(2 DOWNTO 0) := (OTHERS => '0');
SIGNAL strobe_sampler : STD_LOGIC;
SIGNAL strobe_fsm : STD_LOGIC;
SIGNAL start_trigger : STD_LOGIC := '0'; -- Allows detection of falling edge of rx_line without requiring clock to be in perfect sync with falling edge
BEGIN
strobe_gen : ENTITY work.strobe_generator_rx(behavioral) PORT MAP (clk => clk, baud_rate => baud_rate, resync => resync_state, strobe_sampler => strobe_sampler, strobe_fsm => strobe_fsm, error => internal_error);
sampler : ENTITY work.sampler(behavioral) PORT MAP (clk => clk, strobe => strobe_sampler, resync => resync_state, rx_in => rx_line, rx_out => rx_state);
shift_register : ENTITY work.shift_register_rx(behavioral) PORT MAP (clk => clk, parallel_mode => parallel_mode, strobe_in => strobe_fsm, shift_in => rx_state, parallel_data => parallel_data, parity => parity_state, reset => reset_state);

PROCESS (clk)
BEGIN
    IF rising_edge(clk) THEN
        IF fsm_state = INITIAL and strobe_fsm = '1' THEN
            IF initial_counter < X"A" THEN
                initial_counter <= initial_counter + 1;
            ELSE
                initial_counter <= (OTHERS => '0');
                fsm_state <= IDLE;
                resync_state <= '0';
                parallel_mode <= '0';
                reset_state <= '1';
            END IF;
        ELSIF fsm_state = IDLE THEN
            resync_state <= '0'; -- Immediately shuts off resync
            IF rx_line = '0' AND start_trigger = '0' THEN
                start_trigger <= '1';
                resync_state <= '1'; -- Resynchronises system when falling edge of rx line first occurs
                parallel_mode <= '0';
                reset_state <= '0';
            ELSIF start_trigger = '1' AND strobe_fsm = '1' THEN
                IF rx_state = '0' THEN -- Sampler reports 0, the falling edge cannot be noise.
                    fsm_state <= START; -- Advances system rapidly (system clock rate) to START state.
                    resync_state <= '0'; -- Turns off resync to allow system to function effectively.
                    parallel_mode <= '0';
                    reset_state <= '0';
                    start_trigger <= '0'; -- Resets trigger for next byte
                ELSE
                    resync_state <= '0'; -- Turns off resync to allow system to function effectively.
                    start_trigger <= '0'; -- Resets trigger to detect another falling edge
                END IF;
            END IF;
        ELSIF fsm_state = START AND strobe_fsm = '1' THEN
            fsm_state <= SHIFT;
        ELSIF fsm_state = SHIFT AND strobe_fsm = '1' THEN
            IF shift_counter = X"7" THEN
                shift_counter <= (OTHERS => '0');
                fsm_state <= PARITY;
                parallel_mode <= '1'; -- Ensures register stops shifting further bits
                parity_calculated <= parity_state;
            ELSE
                shift_counter <= shift_counter + 1;
            END IF;
        ELSIF fsm_state = PARITY AND strobe_fsm = '1' THEN
            IF rx_state = parity_calculated THEN
                transmission_error <= '0';
            ELSE
            transmission_error <= '1';
            END IF;
            fsm_state <= STOP;
            parallel_mode <= '1'; -- Allows host system to extract the byte recieved
        ELSIF fsm_state = STOP and strobe_fsm = '1' THEN
            fsm_state <= IDLE;
            transmission_error <= '0';
            parallel_mode <= '0';
            resync_state <= '0';
            reset_state <= '1';
        END IF;
    END IF;
END PROCESS;
END behavioral;
