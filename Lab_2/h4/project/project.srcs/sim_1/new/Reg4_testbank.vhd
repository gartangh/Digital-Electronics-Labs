library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, IEEE.STD_LOGIC_UNSIGNED.ALL, IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity Reg4_testbank is

end Reg4_testbank;

architecture gedrag of Reg4_testbank is

    signal clk, reset, enable, run : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    signal data_out : STD_LOGIC_VECTOR(3 downto 0);

    constant periode : TIME := 10 ns;

begin

    UUT : entity work.Reg4(gedrag)
    port map(
        clk => clk,
        reset => reset,
        enable => enable,
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
        reset <= '0';
        wait for 0.5 * periode;
        
        reset <= '1';
        wait for 0.5 * periode;

        run <= '1';
        reset <= '0';
        wait for 1 * periode;

        enable <= '1';
        wait for 1 * periode;

        data_in <= "0001";
        wait for 1 * periode;

        enable <= '0';
        wait for 1 * periode;

        data_in <= "0010";
        wait for 1 * periode;

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
