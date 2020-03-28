----------------------------------------------------------------------------------
-- Module Name: full_adder_cla - gedrag
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_cla is
    port(
        input_1 : in STD_LOGIC;
        input_2 : in STD_LOGIC;
        input_carry : in STD_LOGIC;
        output : out STD_LOGIC;
        output_gen: out STD_LOGIC;
        output_prop: out STD_LOGIC
    );
end full_adder_cla;

architecture gedrag of full_adder_cla is

begin
    output_gen <= input_1 and input_2;
    output_prop <= input_1 or input_2;

    output <= (input_1 xor input_2) xor input_carry;
end gedrag;
