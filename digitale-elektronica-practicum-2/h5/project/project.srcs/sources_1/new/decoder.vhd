library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    port(
            data_in : in STD_LOGIC_VECTOR(4 downto 0);
            data_out_1 : out STD_LOGIC_VECTOR(3 downto 0);
            data_out_2 : out STD_LOGIC_VECTOR(3 downto 0)
        );
end decoder;

architecture gedrag of decoder is
begin
    process(data_in)
    begin
        case data_in is
            when "00000" => -- 0
                data_out_1 <= "0000";
                data_out_2 <= "0000";
            when "00001" => -- 1
                data_out_1 <= "0001";
                data_out_2 <= "0000";
            when "00010" => -- 2
                data_out_1 <= "0010";
                data_out_2 <= "0000";
            when "00011" => -- 3
                data_out_1 <= "0011";
                data_out_2 <= "0000";
            when "00100" => -- 4
                data_out_1 <= "0100";
                data_out_2 <= "0000";
            when "00101" => -- 5
                data_out_1 <= "0101";
                data_out_2 <= "0000";
            when "00110" => -- 6
                data_out_1 <= "0110";
                data_out_2 <= "0000";
            when "00111" => -- 7
                data_out_1 <= "0111";
                data_out_2 <= "0000";
            when "01000" => -- 8
                data_out_1 <= "1000";
                data_out_2 <= "0000";
            when "01001" => -- 9
                data_out_1 <= "1001";
                data_out_2 <= "0000";
            when "01010" => -- 10
                data_out_1 <= "0000";
                data_out_2 <= "0001";
            when "01011" => -- 11
                data_out_1 <= "0001";
                data_out_2 <= "0001";
            when "01100" => -- 12
                data_out_1 <= "0010";
                data_out_2 <= "0001";
            when "01101" => -- 13
                data_out_1 <= "0011";
                data_out_2 <= "0001";
            when "01110" => -- 14
                data_out_1 <= "0100";
                data_out_2 <= "0001";
            when "01111" => -- 15
                data_out_1 <= "0101";
                data_out_2 <= "0001";
            when "10000" => -- 16
                data_out_1 <= "0110";
                data_out_2 <= "0001";
            when "10001" => -- 17
                data_out_1 <= "0111";
                data_out_2 <= "0001";
            when "10010" => -- 18
                data_out_1 <= "1000";
                data_out_2 <= "0001";
            when others =>
                data_out_1 <= "----";
                data_out_2 <= "----";
        end case;
    end process;
end gedrag;

