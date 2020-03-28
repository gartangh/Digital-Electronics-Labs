library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calculator is
    port(
            clk : in std_logic;
            reset : in std_logic;

            counter : in std_logic_vector(3 downto 0);
            counter_enable : out std_logic;

            button_center : in std_logic;
            button_left : in std_logic;
            button_right : in std_logic;

            display_data : out std_logic_vector(15 downto 0);
            display_mask : out std_logic_vector(3 downto 0)
        );
end calculator;

architecture gedrag of calculator is
    signal operand_1_enable : std_logic;
    signal operand_2_enable : std_logic;

    signal operation : std_logic;

    signal view_output : std_logic;
    signal view_wait : std_logic;
begin
    counter_enable <= operand_1_enable or operand_2_enable;

    datapad : entity work.datapad(gedrag)
    port map(
                clk => clk,
                reset => reset,
                operand => counter,
                operand_1_enable => operand_1_enable,
                operand_2_enable => operand_2_enable,
                operation => operation,
                view_output => view_output,
                view_wait => view_wait,
                display_data => display_data,
                display_mask => display_mask
            );

    controller : entity work.controller(gedrag)
    port map(
                clk => clk,
                reset => reset,
                button_center => button_center,
                button_left => button_left,
                button_right => button_right,
                operand_1_enable => operand_1_enable,
                operand_2_enable => operand_2_enable,
                operation => operation,
                view_output => view_output,
                view_wait => view_wait
            );
end gedrag;
