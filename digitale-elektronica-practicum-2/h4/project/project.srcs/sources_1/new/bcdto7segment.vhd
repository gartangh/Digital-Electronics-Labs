library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcdto7segment is

    port(
            data_in : in STD_LOGIC_VECTOR (3 downto 0);
            segments_out : out STD_LOGIC_VECTOR (6 downto 0)
        );

end bcdto7segment;

architecture waarheidstabel of bcdto7segment is

begin

    process(data_in)

    begin

        case data_in is
            when "0000" =>
                segments_out <= "1000000";
            when "0001" =>
                segments_out <= "1111001";
            when "0010" =>
                segments_out <= "0100100";
            when "0011" =>
                segments_out <= "0110000";
            when "0100" =>
                segments_out <= "0011001";
            when "0101" =>
                segments_out <= "0010010";
            when "0110" =>
                segments_out <= "0000010";
            when "0111" =>
                segments_out <= "1111000";
            when "1000" =>
                segments_out <= "0000000";
            when "1001" =>
                segments_out <= "0010000";
            when "1111" =>
                segments_out <= "0111111";
            when others =>
                segments_out <= "XXXXXXX";
        end case;

    end process;

end waarheidstabel;
