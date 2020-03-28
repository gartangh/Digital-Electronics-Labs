library IEEE;
use IEEE.STD_LOGIC_1164.ALL, IEEE.STD_LOGIC_ARITH.ALL, IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_counter is

    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        enable : in STD_LOGIC;
        direction : in STD_LOGIC; -- '0' = add; '1'= subtract;
        data_out : out STD_LOGIC_VECTOR(3 downto 0)
    );

end bcd_counter;

architecture gedrag of bcd_counter is

    signal internal_counter : STD_LOGIC_VECTOR(3 downto 0);

begin

    process(clk, reset)

    begin

        if(reset = '1') then
            internal_counter <= "0000";
        elsif rising_edge(clk) then
            if(enable = '1') then
                if(direction = '0') then -- add
                    if(internal_counter = "1001") then
                        internal_counter <= "0000";
                    else
                        internal_counter <= internal_counter + "0001";
                    end if;
                else -- subtract
                    if(internal_counter = "0000") then
                        internal_counter <= "1001";
                    else
                        internal_counter <= internal_counter - "0001";
                    end if;
                end if;
            else

            end if;
        else
           -- vorige waarde behouden
        end if;

    end process;

    data_out <= internal_counter;

end gedrag;
