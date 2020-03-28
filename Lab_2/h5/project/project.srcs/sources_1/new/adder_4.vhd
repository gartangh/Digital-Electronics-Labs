----------------------------------------------------------------------------------
-- Module Name: adder4 - gedrag
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder4 is
    port(
        input_1 : in STD_LOGIC_VECTOR(3 downto 0);
        input_2 : in STD_LOGIC_VECTOR(3 downto 0);
        input_carry : in STD_LOGIC;
        output_carry : out STD_LOGIC;
        output : out STD_LOGIC_VECTOR(3 downto 0)
    );
end adder4;

architecture cla of adder4 is
    component full_adder_cla
        port(
            input_1 : in STD_LOGIC;
            input_2 : in STD_LOGIC;
            input_carry : in STD_LOGIC;
            output : out STD_LOGIC;
            output_gen: out STD_LOGIC;
            output_prop: out STD_LOGIC
        );
    end component;

    signal gen : STD_LOGIC_VECTOR(3 downto 0);
    signal prop : STD_LOGIC_VECTOR(3 downto 0);
    signal full_adder_cla_input_carry : STD_LOGIC_VECTOR(3 downto 1);
begin
    full_adder_cla_input_carry(1) <= gen(0) or (prop(0) and input_carry);
    full_adder_cla_input_carry(2) <= gen(1) or (prop(1) and full_adder_cla_input_carry(1));
    full_adder_cla_input_carry(3) <= gen(2) or (prop(2) and full_adder_cla_input_carry(2));

    output_carry <= gen(3) or (prop(3) and full_adder_cla_input_carry(3));

    full_adder_cla_1 : full_adder_cla port map(input_1(0), input_2(0), input_carry, output(0), gen(0), prop(0));
    full_adder_cla_2 : full_adder_cla port map(input_1(1), input_2(1), full_adder_cla_input_carry(1), output(1), gen(1), prop(1));
    full_adder_cla_3 : full_adder_cla port map(input_1(2), input_2(2), full_adder_cla_input_carry(2), output(2), gen(2), prop(2));
    full_adder_cla_4 : full_adder_cla port map(input_1(3), input_2(3), full_adder_cla_input_carry(3), output(3), gen(3), prop(3));
end cla;

