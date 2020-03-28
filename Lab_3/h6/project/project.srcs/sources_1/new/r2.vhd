library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity r2 is
    port
    (
        clk        : in  std_logic;                     -- kloksignaal
        reset      : in  std_logic;                     -- resetsignaal (actief hoog)
        din        : in  std_logic_vector (3 downto 0); -- dataingang
        dout       : out std_logic_vector (3 downto 0); -- datauitgang
        dout_ready : out std_logic;                     -- datauitgang bevat een waarde
        ok         : out std_logic;                     -- hoog indien het ontvangen woord correct is
        dreq       : out std_logic;                     -- synchronisatieuitgang (data request)
        dav        : in  std_logic                      -- synchronisatieingang (data available)
    );
end r2;

architecture behaviour of r2 is
    signal enable                    : std_logic;

    type state is
        (
        state_reset,
        state_wait,
        state_enable,
        state_timeout
    );
    signal state_current, state_next : state;
begin
    r1 : entity work.r1(behaviour)
    port map (
                 clk        => clk,
                 reset      => reset,
                 enable     => enable,
                 di         => din,
                 dout       => dout,
                 dout_ready => dout_ready,
                 ok         => ok
             );

    process (clk, reset)
    begin
        if (reset = '1') then
            state_current <= state_reset;
        elsif rising_edge(clk) then
            state_current <= state_next;
        end if;
    end process;

    -- toestandsfunctie
    process (state_current, dav)
    begin
        case state_current is
            when state_reset =>
                state_next <= state_wait;
            when state_wait =>
                if dav = '1' then
                    state_next <= state_enable;
                else
                    state_next <= state_wait;
                end if;
            when state_enable =>
                state_next <= state_timeout;
            when state_timeout =>
                if dav = '0' then
                    state_next <= state_wait;
                else
                    state_next <= state_timeout;
                end if;
            when others =>
                state_next <= state_reset;
        end case;
    end process;

    -- uitgangsfunctie
    process (state_current)
    begin
        case state_current is
            when state_reset =>
                dreq <= '0';
                enable <= '1';
            when state_wait =>
                dreq <= '1';
                enable <= '0';
            when state_enable =>
                dreq <= '1';
                enable <= '1';
            when state_timeout =>
                dreq <= '0';
                enable <= '0';
            when others =>
                dreq <= '0';
                enable <= '0';
        end case;
    end process;
end behaviour;

