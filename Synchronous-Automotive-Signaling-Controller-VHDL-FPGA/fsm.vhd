library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        sw  : in STD_LOGIC_VECTOR (2 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0)
    );
end fsm;

architecture Behavioral of fsm is

    signal dummy_seg0, dummy_seg1, dummy_seg2, dummy_seg3 : std_logic := '0';
    signal dummy_seg4, dummy_seg5, dummy_seg6, dummy_dp : std_logic := '0';
    signal dummy_an0, dummy_an1, dummy_an2, dummy_an3 : std_logic := '0';

    type states is (
        idle,
        LAon, LALBon, LALBLCon, LAoff,
        RAon, RARBon, RARBRCon, RAoff,
        HAZARD1, HAZARD2, HAZARD3, HAZARDOFF
    );

    signal current_state, next_state : states;
    signal LEFT, RIGHT, HAZ : std_logic;
    signal inc_timer : std_logic;

begin

    HAZ <= sw(0);
    LEFT <= sw(1);
    RIGHT <= sw(2);

    -- LED output
    led <= "0000000000000000" when current_state = idle or current_state = LAoff or current_state = RAoff or current_state = HAZARDOFF
       else "0000110000000000" when current_state = LAon
       else "0011110000000000" when current_state = LALBon
       else "1111110000000000" when current_state = LALBLCon
       else "0000000000110000" when current_state = RAon
       else "0000000000111100" when current_state = RARBon
       else "0000000000111111" when current_state = RARBRCon
       else "0000110000110000" when current_state = HAZARD1
       else "0011110000111100" when current_state = HAZARD2
       else "1111110000111111" when current_state = HAZARD3;

    -- Divizor de frecventa (0.25s)
    process(clk, rst)
        variable q : integer := 0;
    begin
        if rst = '1' then
            q := 0;
            inc_timer <= '0';
        elsif rising_edge(clk) then
            if q = 24999999 then
                q := 0;
                inc_timer <= '1';
            else
                q := q + 1;
                inc_timer <= '0';
            end if;
        end if;
    end process;

    -- Actualizare stare curentă
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- FSM
    process(current_state, LEFT, RIGHT, HAZ, inc_timer)
    begin
        case current_state is

            when idle =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '1' then
                    next_state <= LAon;
                elsif RIGHT = '1' then
                    next_state <= RAon;
                else
                    next_state <= idle;
                end if;

            -- SEMNALIZARE STÂNGA
            when LAon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '0' or RIGHT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= LALBon;
                else
                    next_state <= LAon;
                end if;

            when LALBon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '0' or RIGHT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= LALBLCon;
                else
                    next_state <= LALBon;
                end if;

            when LALBLCon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '0' or RIGHT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= LAoff;
                else
                    next_state <= LALBLCon;
                end if;

            when LAoff =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif LEFT = '0' or RIGHT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= LAon;
                else
                    next_state <= LAoff;
                end if;

            -- SEMNALIZARE DREAPTA
            when RAon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif RIGHT = '0' or LEFT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= RARBon;
                else
                    next_state <= RAon;
                end if;

            when RARBon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif RIGHT = '0' or LEFT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= RARBRCon;
                else
                    next_state <= RARBon;
                end if;

            when RARBRCon =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif RIGHT = '0' or LEFT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= RAoff;
                else
                    next_state <= RARBRCon;
                end if;

            when RAoff =>
                if HAZ = '1' then
                    next_state <= HAZARD1;
                elsif RIGHT = '0' or LEFT = '1' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= RAon;
                else
                    next_state <= RAoff;
                end if;

            -- AVARII
            when HAZARD1 =>
                if HAZ = '0' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= HAZARD2;
                else
                    next_state <= HAZARD1;
                end if;

            when HAZARD2 =>
                if HAZ = '0' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= HAZARD3;
                else
                    next_state <= HAZARD2;
                end if;

            when HAZARD3 =>
                if HAZ = '0' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= HAZARDOFF;
                else
                    next_state <= HAZARD3;
                end if;

            when HAZARDOFF =>
                if HAZ = '0' then
                    next_state <= idle;
                elsif inc_timer = '1' then
                    next_state <= HAZARD1;
                else
                    next_state <= HAZARDOFF;
                end if;

            when others =>
                next_state <= idle;

        end case;
    end process;

end Behavioral;
