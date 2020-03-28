library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use STD.TEXTIO.ALL;

entity test_sr2 is
end test_sr2;

architecture behaviour of test_sr2 is
    signal clk1, clk2, reset, dout_ready, ok  : std_logic;
    signal run                                : std_logic                     := '0';

    signal zender_out, ontvanger_in, dout     : std_logic_vector(3 downto 0);

    constant periode1                         : time                          := 10 ns; -- zender
    constant periode2                         : time                          := 10 ns; -- ontvanger
    constant delay1                           : time                          := 1 ns;  -- data(3..1)
    constant delay2                           : time                          := 2 ns;  -- data(0)
    constant delay3                           : time                          := 1 ns;  -- DREQ
    constant delay4                           : time                          := 400 ns;  -- DAV

    signal dreq_in, dreq_out, dav_in, dav_out : std_logic;
begin
    DUT1 : entity work.s2(behaviour)
    port map(
                clk   => clk1,
                reset => reset,
                d     => zender_out,
                dreq  => dreq_in,
                dav   => dav_out
            );

    DUT2 : entity work.r2(behaviour)
    port map(
                clk        => clk2,
                reset      => reset,
                din        => ontvanger_in,
                dout       => dout,
                dout_ready => dout_ready,
                ok         => ok,
                dreq       => dreq_out,
                dav        => dav_in
            );

    -- klok
    process(run, clk1)
    begin
        if (run = '0') then
            clk1 <= '0';
        else
            clk1 <= not(clk1) after periode1 / 2;
        end if;
    end process;

    process(run, clk2)
    begin
        if (run = '0') then
            clk2 <= '0';
        else
            clk2 <= not(clk2) after periode2 / 2;
        end if;
    end process;

    -- reset
    process
    begin
        run <= '1';
        reset <= '1';
        wait for 1 * periode1;

        reset <= '0';
        wait for 1000 * periode1;
    end process;

    ontvanger_in(3 downto 1) <= zender_out(3 downto 1) after delay1;
    ontvanger_in(0) <= zender_out(0) after delay2;
    dreq_in <= dreq_out after delay3;
    dav_in <= dav_out after delay4;
end behaviour;

