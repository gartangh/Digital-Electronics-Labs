library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, IEEE.STD_LOGIC_UNSIGNED.ALL, IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity button_pressed_testbank is

end button_pressed_testbank;

architecture gedrag of button_pressed_testbank is
   
    signal clk, reset, run : STD_LOGIC := '0';
    signal data_in : STD_LOGIC := '0';
    signal data_out : STD_LOGIC;

    constant periode : TIME := 10 ns;

begin

    UUT : entity work.button_pressed(gedrag)
    port map(
        clk => clk,
        reset => reset,
        data_in => data_in,
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

        wait for 1 * periode;

        run <= '1';

        wait for 0.25 * periode;

        data_in <= '1';
        
        wait for 2 * periode;

        data_in <= '0';

        wait for 1.75 * periode;

        run <= '0';

        wait for 1 * periode;

        report "simulation ended"
        
        severity failure;
        -- in dit process gebruik je een 'failure' om de simulatie te laten stoppen:
        -- het process wordt slechts 1 maal uitgevoerd
    
    end process;

end gedrag;
