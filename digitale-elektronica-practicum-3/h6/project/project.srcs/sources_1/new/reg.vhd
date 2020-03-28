library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    generic(n : integer);
    port(
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            data_in : in std_logic_vector(n - 1 downto 0);
            data_out : out std_logic_vector(n - 1 downto 0)
        );
end reg;

architecture behaviour of reg is
begin
    process(clk, reset)
        constant zeros : std_logic_vector(n - 1 downto 0) := (others => '0');
    begin
        if(reset = '1') then
            data_out <= zeros;
        elsif rising_edge(clk) then
            if(enable = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;
end behaviour;

