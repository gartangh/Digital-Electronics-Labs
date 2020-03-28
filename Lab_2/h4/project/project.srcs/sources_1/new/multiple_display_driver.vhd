library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity multiple_display_driver is

    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR(15 downto 0);
        display_mask : in STD_LOGIC_VECTOR(3 downto 0);
        an_out : out STD_LOGIC_VECTOR(3 downto 0);
        seg_out : out STD_LOGIC_VECTOR(6 downto 0)
    );

end multiple_display_driver;

architecture gedrag of multiple_display_driver is

    signal data_selector : STD_LOGIC_VECTOR(15 downto 0);
    signal data_internal : STD_LOGIC_VECTOR(3 downto 0);
    signal internal_display_mask : STD_LOGIC_VECTOR(3 downto 0);
    signal internal_display_selector: STD_LOGIC_VECTOR(3 downto 0);

begin

    decoder : entity work.bcdto7segment(waarheidstabel)
        port map(
            data_in => data_internal,
            segments_out => seg_out
        );

    -- maak vector van resetsignalen 
    -- om ervoor te zorgen dat geen enkele display aan staat tijdens reset
    process(reset, display_mask)
    
    begin
        
        if(reset = '1') then
            internal_display_mask <= "1111";
        else
            internal_display_mask <= not(display_mask);
        end if;

    end process;

    -- merk op: display_mask bevat 1-tjes voor alle displays die actief moeten zijn
    -- aangezien een inactieve display een anode-signaal gelijk aan 1 heeft
    -- moeten we hieronder een or doen met het inverse van display mask 
    -- d.w.z. een display_mask van "1111" heeft geen effect (alle displays werken)
    -- en een display_mask van "0000" zet alle displays uit (alle anodes = 1).

    selector : process(clk, reset)
    
    begin
    
        if(reset = '1') then
            data_selector <= "1111111111111111";
        elsif rising_edge(clk) then    
            if (data_selector="1111111111111111") then
                data_selector <= "0000000000000000";
            else
                data_selector <= data_selector + "0000000000000001";
            end if;
        end if; 
    
    end process;

    sw_multiplexer : process(data_selector(15 downto 14), data_in, internal_display_mask) 
    
    begin
    
        case data_selector(15 downto 14) is
            when "00" => 
                data_internal <= data_in(3 downto 0);
                internal_display_selector <= "1110";
            when "01" => 
                data_internal <= data_in(7 downto 4);
                internal_display_selector <= "1101";
            when "10" => 
                data_internal <= data_in(11 downto 8);
                internal_display_selector <= "1011";
            when "11" => 
                data_internal <= data_in(15 downto 12);
                internal_display_selector <= "0111";
            when others =>
                data_internal <= "XXXX";
                internal_display_selector <= "XXXX";
        end case;
    
    end process;

    an_out <= internal_display_mask or internal_display_selector;

end gedrag;
