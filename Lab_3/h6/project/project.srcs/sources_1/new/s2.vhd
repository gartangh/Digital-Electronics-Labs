library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity s2 is
    port
    (
        clk   : in  std_logic;                     -- kloksignaal
        reset : in  std_logic;                     -- resetsignaal (actief hoog)
        d     : out std_logic_vector (3 downto 0); -- datauitgang
        dreq  : in  std_logic;                     -- synchronisatieingang (data request)
        dav   : out std_logic                      -- synchronisatieuitgang (data available)
    );
end s2;

architecture behaviour of s2 is
    signal enable                    : std_logic;
    signal d_enable                  : std_logic;
    signal d_buffer                  : std_logic_vector(3 downto 0);

    type state is
        (
        state_wait,
        state_data_generation,
        state_pre_data_available,
        state_data_available,
        state_post_data_available
    );

    signal state_current, state_next : state;
begin
    s1 : entity work.s1(behaviour)
    port map(
                clk 	=> clk,
                reset 	=> reset,
                enable	=> enable,
                d 		=> d_buffer
            );

    -- multiplexer
    process(d_enable, d_buffer)
    begin
        case d_enable is
            when '1' =>
                d <= d_buffer;
            when others =>
                d <= "ZZZZ";
        end case;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            state_current <= state_wait;
        elsif rising_edge(clk) then
            state_current <= state_next;
        end if;
    end process;

    -- toestandsfunctie
    process(state_current, dreq)
    begin
        case state_current is
            when state_wait =>
                if dreq = '1' then
                    state_next <= state_data_generation;
                else
                    state_next <= state_wait;
                end if;
            when state_data_generation =>
                state_next <= state_pre_data_available;
            when state_pre_data_available =>
                state_next <= state_data_available;
            when state_data_available =>
                if dreq = '0' then
                    state_next <= state_post_data_available;
                else
                    state_next <= state_data_available;
                end if;
            when state_post_data_available =>
                state_next <= state_wait;
            when others =>
                state_next <= state_wait;
        end case;
    end process;

    -- uitgangsfunctie
    process(state_current)
    begin
        case state_current is
            when state_wait =>
                d_enable <= '0';
                dav <= '0';
                enable <= '0';
            when state_data_generation =>
                d_enable <= '0';
                dav <= '0';
                enable <= '1';
            when state_pre_data_available =>
                d_enable <= '1';
                dav <= '0';
                enable <= '0';
            when state_data_available =>
                d_enable <= '1';
                dav <= '1';
                enable <= '0';
            when state_post_data_available =>
                d_enable <= '1';
                dav <= '0';
                enable <= '0';
            when others =>
                d_enable <= '0';
                dav <= '0';
                enable <= '0';
        end case;
    end process;
end behaviour;

