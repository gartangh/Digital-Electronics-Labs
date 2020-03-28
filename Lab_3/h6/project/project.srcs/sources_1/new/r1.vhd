library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity r1 is
    port
    (
        clk        : in  std_logic;                     -- kloksignaal
        reset      : in  std_logic;                     -- resetsignaal (actief hoog)
        enable     : in  std_logic;                     -- enable signaal (actief hoog)
        di         : in  std_logic_vector (3 downto 0); -- dataingang
        dout       : out std_logic_vector (3 downto 0); -- datauitgang
        dout_ready : out std_logic;                     -- datauitgang bevat een waarde
        ok         : out std_logic                      -- hoog indien het ontvangen woord correct is
    );
end r1;

architecture behaviour of r1 is
    signal registers_enable          : std_logic;
    signal register_1_data           : std_logic_vector(3 downto 0);
    signal register_2_data           : std_logic_vector(3 downto 0);
    signal word_generator_enable     : std_logic;
    signal word_generator_data       : std_logic_vector(3 downto 0);

    signal dout_ready_buffer         : std_logic;

    type state is
        (
        state_reset,
        state_previous_enable_low,
        state_previous_enable_high
    );
    signal state_current, state_next : state;
begin
    register_1 : entity work.reg(behaviour)
    generic map(n => 4)
    port map(
                clk      => clk,
                reset    => reset,
                enable   => registers_enable,
                data_in  => di,
                data_out => register_1_data
            );

    register_2 : entity work.reg(behaviour)
    generic map(n => 4)
    port map(
                clk      => clk,
                reset    => reset,
                enable   => registers_enable,
                data_in  => word_generator_data,
                data_out => register_2_data
            );

    dout <= register_1_data;

    word_generator : entity work.word_generator(behaviour)
    port map(
                clk    => clk,
                reset  => reset,
                enable => word_generator_enable,
                data   => word_generator_data
            );

    process(clk, reset)
    begin
        if reset = '1' then
            state_current <= state_reset;
        elsif rising_edge(clk) then
            state_current <= state_next;
        end if;
    end process;

    -- toestandsfunctie
    process(state_current, enable)
    begin
        case state_current is
            when state_reset =>
                if enable = '1' then
                    state_next <= state_previous_enable_low;
                else
                    state_next <= state_reset;
                end if;
            when state_previous_enable_low =>
                if enable = '1' then
                    state_next <= state_previous_enable_high;
                else
                    state_next <= state_previous_enable_low;
                end if;
            when state_previous_enable_high =>
                if enable = '1' then
                    state_next <= state_previous_enable_high;
                else
                    state_next <= state_previous_enable_low;
                end if;
            when others =>
                state_next <= state_reset;
        end case;
    end process;

    -- uitgangsfunctie
    process(state_current, enable)
    begin
        case state_current is
            when state_reset =>
                dout_ready_buffer <= '0';
                registers_enable <= '0';
                word_generator_enable <= '1';
            when state_previous_enable_low =>
                if enable = '1' then
                    dout_ready_buffer <= '0';
                    registers_enable <= '1';
                    word_generator_enable <= '1';
                else
                    dout_ready_buffer <= '0';
                    registers_enable <= '0';
                    word_generator_enable <= '0';
                end if;
            when state_previous_enable_high =>
                if enable = '1' then
                    dout_ready_buffer <= '1';
                    registers_enable <= '1';
                    word_generator_enable <= '1';
                else
                    dout_ready_buffer <= '1';
                    registers_enable <= '0';
                    word_generator_enable <= '0';
                end if;
            when others =>
                dout_ready_buffer <= '0';
                registers_enable <= '0';
                word_generator_enable <= '0';
        end case;
    end process;

    dout_ready <= dout_ready_buffer;

    -- combinatorische module die het 'ok' signaal genereert
    process(dout_ready_buffer, register_1_data, register_2_data)
    begin
        if dout_ready_buffer = '1' and register_1_data = register_2_data then
            ok <= '1';
        else
            ok <= '0';
        end if;
    end process;
end behaviour;

