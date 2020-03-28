library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    port(
            clk : in std_logic;
            reset : in std_logic;

            button_center : in std_logic;
            button_left : in std_logic;
            button_right : in std_logic;

            operand_1_enable : out std_logic;
            operand_2_enable : out std_logic;

            operation : out std_logic;

            view_output : out std_logic;
            view_wait : out std_logic
        );
end controller;

architecture gedrag of controller is
    type state is (state_wait, state_operand_1, state_operand_2, state_operation, state_result_add, state_result_subtract);

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
    process(state_current, button_center, button_left, button_right)
    begin
        case state_current is
            when state_wait =>
                if(button_center = '1') then
                    state_next <= state_operand_1;
                else
                    state_next <= state_wait;
                end if;
            when state_operand_1 =>
                if(button_center = '1') then
                    state_next <= state_operand_2;
                else
                    state_next <= state_operand_1;
                end if;
            when state_operand_2 =>
                if(button_center = '1') then
                    state_next <= state_operation;
                else
                    state_next <= state_operand_2;
                end if;
            when state_operation =>
                if(button_left = '1') then
                    state_next <= state_result_subtract;
                elsif(button_right = '1') then
                    state_next <= state_result_add;
                else
                    state_next <= state_operation;
                end if;
            when state_result_add =>
                if(button_center = '1') then
                    state_next <= state_operand_1;
                else
                    state_next <= state_result_add;
                end if;
            when state_result_subtract =>
                if(button_center = '1') then
                    state_next <= state_operand_1;
                else
                    state_next <= state_result_subtract;
                end if;
        end case;
    end process;

    -- uitgangsfunctie
    process(state_current)
    begin
        case state_current is
            when state_wait =>
                operand_1_enable <= '0';
                operand_2_enable <= '0';
                operation <= '0';
                view_output <= '0';
                view_wait <= '1';
            when state_operand_1 =>
                operand_1_enable <= '1';
                operand_2_enable <= '0';
                operation <= '0';
                view_output <= '0';
                view_wait <= '0';
            when state_operand_2 =>
                operand_1_enable <= '0';
                operand_2_enable <= '1';
                operation <= '0';
                view_output <= '0';
                view_wait <= '0';
            when state_operation =>
                operand_1_enable <= '0';
                operand_2_enable <= '0';
                operation <= '0';
                view_output <= '0';
                view_wait <= '0';
            when state_result_add =>
                operand_1_enable <= '0';
                operand_2_enable <= '0';
                operation <= '0';
                view_output <= '1';
                view_wait <= '0';
            when state_result_subtract =>
                operand_1_enable <= '0';
                operand_2_enable <= '0';
                operation <= '1';
                view_output <= '1';
                view_wait <= '0';
            when others =>
                operand_1_enable <= '0';
                operand_2_enable <= '0';
                operation <= '0';
                view_output <= '0';
                view_wait <= '1';
        end case;
    end process;
end gedrag;

