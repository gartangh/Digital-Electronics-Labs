library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity test_data_input is
    port(
        btnC, btnU, btnD : in std_logic;
        clk : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0)
    );
end test_data_input;

architecture gedrag of test_data_input is
    signal reset : std_logic;
    signal enable, direction : std_logic;
    signal data_out_up, data_out_down : std_logic;
    signal data_out_extended : std_logic_vector(15 downto 0);
    signal data_out : std_logic_vector(3 downto 0);

    constant display_mask : std_logic_vector(3 downto 0) := "0001";
begin
    button_pressed_up : entity work.button_pressed(gedrag)
    port map(
        clk => clk,
        reset => btnC,
        data_in => btnU,
        data_out => data_out_up
    );

    button_pressed_down : entity work.button_pressed(gedrag)
    port map(
        clk => clk,
        reset => btnC,
        data_in => btnD,
        data_out => data_out_down
    );

    data_out_extended <= "000000000000" & data_out;

    multiple_display_driver : entity work.multiple_display_driver(gedrag)
    port map(
        clk => clk,
        reset => btnC,
        data_in => data_out_extended,
        display_mask => "0001",
        an_out => an,
        seg_out => seg
    );

    bcd_counter : entity work.bcd_counter(gedrag)
    port map(
        clk => clk,
        reset => btnC,
        enable => enable,
        direction => direction,
        data_out => data_out
    );

    enable <= data_out_down or data_out_up;

    direction <= data_out_down;
end gedrag;

