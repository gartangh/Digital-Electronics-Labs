library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is
    generic(n : integer);
    port(
            selector: in std_logic;
            data_in_1 : in std_logic_vector(n - 1 downto 0);
            data_in_2 : in std_logic_vector(n - 1 downto 0);
            data_out : out std_logic_vector(n - 1 downto 0)
        );
end multiplexer;

architecture gedrag of multiplexer is
begin
    process(data_in_1, data_in_2, selector)
        constant dont_cares : std_logic_vector(n - 1 downto 0) := (others => '-');
    begin
        case selector is
            when '0' =>
                data_out <= data_in_1;
            when '1' =>
                data_out <= data_in_2;
            when others =>
                data_out <= dont_cares;
        end case;
    end process;
end gedrag;

