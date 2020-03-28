library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_subtract is
    port(
            data_in_1 : in std_logic_vector(3 downto 0);
            data_in_2 : in std_logic_vector(3 downto 0);

            operation : in std_logic;

            data_out : out std_logic_vector(3 downto 0);

            carry : out std_logic;
            sign : out std_logic
        );
end add_subtract;

architecture gedrag of add_subtract is
    signal data_in_1_not : std_logic_vector(3 downto 0);
    signal data_in_2_not : std_logic_vector(3 downto 0);

    signal multiplexer_1_data : std_logic_vector(3 downto 0);
    signal multiplexer_2_data : std_logic_vector(3 downto 0);

    signal adder_1_output : std_logic_vector(3 downto 0);
    signal adder_2_output : std_logic_vector(3 downto 0);

    signal adder_1_carry : std_logic;
    signal adder_2_carry : std_logic;

    signal adder_selector : std_logic;
begin
    data_in_1_not <= not(data_in_1);
    data_in_2_not <= not(data_in_2);

    multiplexer_1 : entity work.multiplexer(gedrag)
    generic map(n => 4)
    port map(
                data_in_1 => data_in_1,
                data_in_2 => data_in_1_not,
                data_out => multiplexer_1_data,
                selector => operation
            );

    multiplexer_2 : entity work.multiplexer(gedrag)
    generic map(n => 4)
    port map(
                data_in_1 => data_in_2,
                data_in_2 => data_in_2_not,
                data_out => multiplexer_2_data,
                selector => operation
            );

    adder_1 : entity work.adder4(cla)
    port map(
                input_1 => data_in_1,
                input_2 => multiplexer_2_data,
                input_carry => operation,
                output_carry => adder_1_carry,
                output => adder_1_output
            );

    adder_2 : entity work.adder4(cla)
    port map(
                input_1 => data_in_2,
                input_2 => multiplexer_1_data,
                input_carry => operation,
                output_carry => adder_2_carry,
                output => adder_2_output
            );

    multiplexer_3 : entity work.multiplexer(gedrag)
    generic map(n => 4)
    port map(
                data_in_1 => adder_1_output,
                data_in_2 => adder_2_output,
                data_out => data_out,
                selector => adder_2_carry
            );

    sign <= not(adder_1_carry) and operation;

    carry <= adder_2_carry and not(operation);
end gedrag;
