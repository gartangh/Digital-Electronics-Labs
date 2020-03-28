library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_to_segments is
    port(
            data : in STD_LOGIC_VECTOR (3 downto 0);
            segments : out STD_LOGIC_VECTOR (6 downto 0)
        );
end bcd_to_segments;

architecture gedrag of bcd_to_segments is
begin
    process(data)
    begin
        case data is
            when "0000" =>
                segments <= "1000000";
            when "0001" =>
                segments <= "1111001";
            when "0010" =>
                segments <= "0100100";
            when "0011" =>
                segments <= "0110000";
            when "0100" =>
                segments <= "0011001";
            when "0101" =>
                segments <= "0010010";
            when "0110" =>
                segments <= "0000010";
            when "0111" =>
                segments <= "1111000";
            when "1000" =>
                segments <= "0000000";
            when "1001" =>
                segments <= "0010000";
            when "1111" =>
                segments <= "0111111";
            when others =>
                segments <= "XXXXXXX";
        end case;
    end process;
end gedrag;
