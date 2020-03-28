library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calculator_top is
    port(
            clk : in std_logic;

            btnC : in std_logic;
            btnU : in std_logic;
            btnL : in std_logic;
            btnR : in std_logic;
            btnD : in std_logic;

            sw : in std_logic_vector(0 downto 0);

            an : out std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
end calculator_top;

architecture gedrag of calculator_top is
    signal reset : std_logic;

    signal button_center : std_logic;
    signal button_up : std_logic;
    signal button_left : std_logic;
    signal button_right : std_logic;
    signal button_down : std_logic;

    signal counter : std_logic_vector(3 downto 0);
    signal counter_enable : std_logic;
    signal counter_direction : std_logic;

    -- variable to disable the counter despite button_up and button_down
    signal calculator_counter_enable : std_logic;

    signal display_data : std_logic_vector(15 downto 0);
    signal display_mask : std_logic_vector(3 downto 0);
begin
    reset <= sw(0);

    button_pressed_center : entity work.button_pressed(gedrag)
    port map(
                clk => clk,
                reset => reset,
                data_in => btnC,
                data_out => button_center
            );

    button_pressed_up : entity work.button_pressed(gedrag)
    port map(
                clk => clk,
                reset => reset,
                data_in => btnU,
                data_out => button_up
            );

    button_pressed_left : entity work.button_pressed(gedrag)
    port map(
                clk => clk,
                reset => reset,
                data_in => btnL,
                data_out => button_left
            );

    button_pressed_right : entity work.button_pressed(gedrag)
    port map(
                clk => clk,
                reset => reset,
                data_in => btnR,
                data_out => button_right
            );

    button_pressed_down : entity work.button_pressed(gedrag)
    port map(
                clk => clk,
                reset => reset,
                data_in => btnD,
                data_out => button_down
            );

    counter_direction <= button_down;
    counter_enable <= (button_up or button_down) and calculator_counter_enable;

    bcd_counter : entity work.bcd_counter(gedrag)
    port map(
                clk => clk,
                reset => reset,
                enable => counter_enable,
                direction => counter_direction,
                data_out => counter
            );

    calculator : entity work.calculator(gedrag)
    port map(
                clk => clk,
                reset => reset,
                counter => counter,
                counter_enable => calculator_counter_enable,
                button_center => button_center,
                button_left => button_left,
                button_right => button_right,
                display_data => display_data,
                display_mask => display_mask
            );

    multiple_display_driver : entity work.multiple_display_driver(gedrag)
    port map(
                clk => clk,
                reset => reset,
                display_data => display_data,
                display_mask => display_mask,
                anodes => an,
                segments => seg
            );
end gedrag;
