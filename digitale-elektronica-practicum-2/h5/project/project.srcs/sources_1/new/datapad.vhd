library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapad is
    port(
            clk : in std_logic;
            reset : in std_logic;

            operand : in std_logic_vector(3 downto 0);

            operand_1_enable : in std_logic;
            operand_2_enable : in std_logic;

            operation : in std_logic;

            view_output : in std_logic;
            view_wait : in std_logic;

            display_data : out std_logic_vector(15 downto 0);
            display_mask : out std_logic_vector(3 downto 0)
        );
end datapad;

architecture gedrag of datapad is
    signal operand_1 : std_logic_vector(3 downto 0);
    signal operand_2 : std_logic_vector(3 downto 0);

    signal operand_extended : std_logic_vector(4 downto 0);

    signal add_subtract_output : std_logic_vector(3 downto 0);
    signal add_subtract_carry : std_logic;
    signal add_subtract_sign : std_logic;

    signal add_subtract_output_extended : std_logic_vector(4 downto 0);

    signal decoder_input : std_logic_vector(4 downto 0);

    signal internal_display_data_1 : std_logic_vector(3 downto 0);
    signal internal_display_data_2 : std_logic_vector(3 downto 0);
    signal internal_display_data_3 : std_logic_vector(3 downto 0);

    signal internal_display_data : std_logic_vector(15 downto 0);
    signal internal_display_mask : std_logic_vector(3 downto 0);
begin
    register_operand_1 : entity work.reg(gedrag)
    generic map(n => 4)
    port map(
                clk => clk,
                reset => reset,
                enable => operand_1_enable,
                data_in => operand,
                data_out => operand_1
            );

    register_operand_2 : entity work.reg(gedrag)
    generic map(n => 4)
    port map(
                clk => clk,
                reset => reset,
                enable => operand_2_enable,
                data_in => operand,
                data_out => operand_2
            );

    add_subtract : entity work.add_subtract(gedrag)
    port map(
                data_in_1 => operand_1,
                data_in_2 => operand_2,
                operation => operation,
                data_out => add_subtract_output,
                carry => add_subtract_carry,
                sign => add_subtract_sign
            );

    operand_extended <= '0' & operand;

    add_subtract_output_extended <= (add_subtract_carry and not(add_subtract_sign)) & add_subtract_output;

    multiplexer_decoder : entity work.multiplexer(gedrag)
    generic map(n =>5)
    port map(
                selector => view_output,
                data_in_1 => operand_extended,
                data_in_2 => add_subtract_output_extended,
                data_out => decoder_input
            );

    decoder : entity work.decoder(gedrag)
    port map(
                data_in => decoder_input,
                data_out_1 => internal_display_data_1,
                data_out_2 => internal_display_data_2
            );

    multiplexer_minus_sign : entity work.multiplexer(gedrag)
    generic map(n => 4)
    port map(
                selector => add_subtract_sign,
                data_in_1 => "0000",
                data_in_2 => "1111",
                data_out => internal_display_data_3
            );

    internal_display_data <= "0000" & internal_display_data_3 & internal_display_data_2 & internal_display_data_1;

    multiplexer_display_data : entity work.multiplexer(gedrag)
    generic map(n => 16)
    port map(
                selector => view_wait,
                data_in_1 => internal_display_data,
                data_in_2 => x"FFFF",
                data_out => display_data
            );

    internal_display_mask <= '0' & (view_output and add_subtract_sign) & internal_display_data_2(0) & '1';

    multiplexer_display_mask : entity work.multiplexer(gedrag)
    generic map(n => 4)
    port map(
                selector => view_wait,
                data_in_1 => internal_display_mask,
                data_in_2 => "1111",
                data_out => display_mask
            );
end gedrag;

