library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_pressed is
    port(
        clk : in std_logic;
        reset : in std_logic;
        data_in : in std_logic;
        data_out : out std_logic
    );
end button_pressed;

architecture gedrag of button_pressed is
    type state is (state_wait, state_not_pressed, state_pressed, state_released);

    signal state_current, state_next : state;
begin
    process(clk, reset)
    begin
        if(reset = '1') then
            state_current <= state_wait;
        elsif rising_edge(clk) then
            state_current <= state_next;
        end if;
    end process;

    -- toestandsfunctie
    process(state_current, data_in)
    begin
        case state_current is
            when state_wait =>
                if(data_in = '1') then
                    state_next <= state_pressed;
                else
                    state_next <= state_not_pressed;
                end if;
            when state_not_pressed =>
                if(data_in = '1') then
                    state_next <= state_pressed;
                else
                    state_next <= state_not_pressed;
                end if;
            when state_pressed =>
                if(data_in = '1') then
                    state_next <= state_pressed;
                else
                    state_next <= state_released;
                end if;
            when state_released =>
                state_next <= state_not_pressed;
            when others =>
                null;
        end case;
    end process;

    -- uitgangsfunctie
    data_out <= '1' when (state_current = state_released) else '0';
end gedrag;

