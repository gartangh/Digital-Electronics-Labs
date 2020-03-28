library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is

    generic(N : INTEGER);

    port(
        selector: in STD_LOGIC;
        data_in_1 : in STD_LOGIC_VECTOR(N - 1 downto 0);
        data_in_2 : in STD_LOGIC_VECTOR(N - 1 downto 0);
        data_out : out STD_LOGIC_VECTOR(N - 1 downto 0)
    );

end multiplexer;

architecture gedrag of multiplexer is

begin

    process(data_in_1, data_in_2, selector)

        constant dont_cares : STD_LOGIC_VECTOR(N - 1 downto 0) := (others => '-');

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
