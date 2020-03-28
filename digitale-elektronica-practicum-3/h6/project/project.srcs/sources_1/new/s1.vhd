library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity s1 is
    port
    (
        clk      : in  std_logic;                    -- kloksignaal
        reset    : in  std_logic;                    -- resetsignaal (actief hoog)
        enable   : in  std_logic;                    -- enable signaal (actief hoog)
        d        : out std_logic_vector (3 downto 0) -- datauitgang
    );
end s1;

architecture behaviour of s1 is
begin
    word_generator : entity work.word_generator(behaviour)
    port map(
                clk    => clk,
                reset  => reset,
                enable => enable,
                data   => d
            );
end behaviour;

