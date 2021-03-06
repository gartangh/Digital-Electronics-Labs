library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter_testbank is

end bcd_counter_testbank;

architecture gedrag of bcd_counter_testbank is

    signal clk, reset, enable, direction, run : STD_LOGIC := '0';
    signal data_out : STD_LOGIC_VECTOR(3 downto 0);
    
    constant periode : TIME := 10 ns;

begin

    UUT : entity work.bcd_counter(gedrag)
    port map(
        clk => clk,
        reset => reset,
        enable => enable,
        direction => direction,
        data_out => data_out
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

        run <= '0';
        reset <= '0';
        wait for 0.5 * periode;
        
        reset <= '1';
        wait for 0.5 * periode;

        run <= '1';
        reset <= '0';
        wait for 1 * periode;

        enable <= '1';
        wait for 10 * periode;

        enable <= '0';
        wait for 2 * periode;

        enable <= '1';
        direction <= '1';
        wait for 11 * periode;

        enable <= '0';
        wait for 2 * periode;

        enable <= '1';
        wait for 0.25 * periode;

        enable <= '0';
        wait for 0.75 * periode;

        reset <= '1';
        wait for 0.25 * periode;

        reset <= '0';
        wait for 0.75 * periode;

        run <= '0';
        wait for 1 * periode;

        report "simulation ended"
        
        severity failure;
        -- in dit process gebruik je een 'failure' om de simulatie te laten stoppen:
        -- het process wordt slechts 1 maal uitgevoerd
    
    end process;

end gedrag;
