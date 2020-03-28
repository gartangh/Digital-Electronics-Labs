library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegN is
    generic(n : integer);
    port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(n - 1 downto 0);
            data_out : out std_logic_vector(n - 1 downto 0)
        );
end RegN;

architecture gedrag of RegN is
begin
    process(clk, reset)
        constant zeros : std_logic_vector(n - 1 downto 0) := (others => '0');
    begin
        if(reset = '1') then
            data_out <= zeros;
        elsif(rising_edge(clk) and enable = '1') then
            data_out <= data_in;
        end if;
    end process;
end gedrag;

