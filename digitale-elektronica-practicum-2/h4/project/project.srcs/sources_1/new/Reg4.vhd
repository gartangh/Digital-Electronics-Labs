library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg4 is
    port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(3 downto 0);
            data_out : out std_logic_vector(3 downto 0)
        );
end Reg4;

architecture gedrag of Reg4 is
begin
    process(clk, reset)
    begin
        if(reset = '1') then
            data_out <= "0000";
        elsif(rising_edge(clk) and enable = '1') then
            data_out <= data_in;
        end if;
    end process;
end gedrag;

