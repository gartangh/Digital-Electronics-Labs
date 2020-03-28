library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity word_generator is
    port(
            clk    : in  std_logic;
            reset  : in  std_logic;
            enable : in  std_logic;
            data   : out std_logic_vector(3 downto 0)
        );
end word_generator;

architecture behaviour of word_generator is
    type state is
        (
        state_reset,
        state_1,
        state_2,
        state_3,
        state_4,
        state_5,
        state_6,
        state_7,
        state_8,
        state_9,
        state_10,
        state_11,
        state_12
    );
    signal state_current, state_next : state;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state_current <= state_reset;
        elsif rising_edge(clk) and enable = '1' then
            state_current <= state_next;
        end if;
    end process;

    -- toestandsfunctie
    process(state_current)
    begin
        case state_current is
            when state_reset =>
                state_next <= state_1;
            when state_1 =>
                state_next <= state_2;
            when state_2 =>
                state_next <= state_3;
            when state_3 =>
                state_next <= state_4;
            when state_4 =>
                state_next <= state_5;
            when state_5 =>
                state_next <= state_6;
            when state_6 =>
                state_next <= state_7;
            when state_7 =>
                state_next <= state_8;
            when state_8 =>
                state_next <= state_9;
            when state_9 =>
                state_next <= state_10;
            when state_10 =>
                state_next <= state_11;
            when state_11 =>
                state_next <= state_12;
            when state_12 =>
                state_next <= state_1;
            when others =>
                state_next <= state_reset;
        end case;
    end process;

    -- uitgangsfunctie
    process(state_current)
    begin
        case state_current is
            when state_reset =>
                data <= "0000";
            when state_1 =>
                data <= "1111";
            when state_2 =>
                data <= "1010";
            when state_3 =>
                data <= "1010";
            when state_4 =>
                data <= "1111";
            when state_5 =>
                data <= "1001";
            when state_6 =>
                data <= "0101";
            when state_7 =>
                data <= "1111";
            when state_8 =>
                data <= "0100";
            when state_9 =>
                data <= "1001";
            when state_10 =>
                data <= "1111";
            when state_11 =>
                data <= "0101";
            when state_12 =>
                data <= "0010";
            when others =>
                data <= "----";
        end case;
    end process;
end behaviour;

