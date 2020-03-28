library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_word_generator is
    end test_word_generator;

architecture behaviour of test_word_generator is
    signal clk : std_logic := '0';
    signal reset : std_logic;
    signal enable : std_logic;

    signal data : std_logic_vector (3 downto 0);

    signal run : std_logic;

    constant periode : time := 10 ns;
begin
    DUT : entity work.word_generator(behaviour)
    port map(
                clk => clk,
                reset => reset,
                enable => enable,
                data => data
            );

    -- klokgenerator
    process(run, clk)
    begin
        if(run = '0') then
            clk <= '0';
        else
            clk <= not(clk) after periode / 2;
        end if;
    end process;

    -- hoofdproces
    process
    begin
        reset <= '1';
        run <= '1';
        enable <= '1';
        wait for 2 * periode;

        reset <= '0';
        wait for 14 * periode;

        enable <= '0';
        wait for 2 * periode;

        report "simulation ended"
        severity failure;
    end process;
end behaviour;

