library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

use STD.TEXTIO.ALL;

entity testbank_calculator is
    end testbank_calculator;

architecture gedrag of testbank_calculator is
    signal clk : std_logic;
    signal reset : std_logic := '1';

    signal counter : std_logic_vector(3 downto 0) := "0000";
    signal counter_enable : std_logic;

    signal button_center : std_logic := '0';
    signal button_left : std_logic := '0';
    signal button_right : std_logic := '0';

    signal display_data : std_logic_vector(15 downto 0);
    signal display_mask : std_logic_vector(3 downto 0);

    -- Interne signalen van de testbank
    file file_testbank_calculator : text;

    signal desired_display_data : std_logic_vector(15 downto 0) := x"FFFF";
    signal desired_display_mask : std_logic_vector(3 downto 0) := "1111";

    signal line_number : integer := 0;
    signal lines_correct : integer := 0;

    signal run, finished : std_logic := '0';

    constant periode : time := 10 ns;
begin
    DUT : entity work.calculator(gedrag)
    port map(
                clk => clk,
                reset => reset,
                counter => counter,
                counter_enable => counter_enable,
                button_center => button_center,
                button_left => button_left,
                button_right => button_right,
                display_data => display_data,
                display_mask => display_mask
            );

    process
    begin
        file_open(file_testbank_calculator, "testbank_calculator.mem", read_mode);

        run <= '0';
        wait for periode;

        run <= '1';
        wait until (finished = '1');

        run <= '0';
        wait for periode;

        file_close(file_testbank_calculator);

        report "Simulation ended!"
        severity failure;
    end process;

    process(run, clk)
    begin
        if (run = '0') then
            clk <= '0';
        else
            clk <= not(clk) after periode;
        end if;
    end process;

    process(clk)
        variable line_read : line;

        variable text_reset : std_logic;
        variable text_buttons : std_logic_vector(2 downto 0);
        variable text_counter : std_logic_vector(3 downto 0);
        variable text_desired_display_data : std_logic_vector(15 downto 0);
        variable text_desired_display_mask : std_logic_vector(3 downto 0);

        variable space : character;
    begin
        if rising_edge(clk) then
            if endfile(file_testbank_calculator) then
                finished <= '1';
            else
                finished <= '0';

                readline(file_testbank_calculator, line_read);

                line_number <= line_number + 1;

                while(line_read(1) = '#' and not(endfile(file_testbank_calculator))) loop
                    line_number <= line_number + 1;

                    writeline(output, line_read);

                    readline(file_testbank_calculator, line_read);
                end loop;

                read(line_read, text_reset);
                read(line_read, space);
                read(line_read, text_buttons);
                read(line_read, space);
                read(line_read, text_counter);
                read(line_read, space);
                read(line_read, text_desired_display_data);
                read(line_read, space);
                read(line_read, text_desired_display_mask);

                reset <= text_reset;

                button_center <= text_buttons(2);
                button_left <= text_buttons(1);
                button_right <= text_buttons(0);

                counter <= text_counter;

                desired_display_data <= text_desired_display_data;
                desired_display_mask <= text_desired_display_mask;
            end if;
        end if;
    end process;

    process(clk)
        variable s : line;
    begin
        if rising_edge(clk) then
            if (display_data = desired_display_data and display_mask = desired_display_mask) then
                lines_correct <= lines_correct + 1;

                write(s, lines_correct + 1);
                write(s, string'(" / "));
                write(s, line_number + 1);
                write(s, string'(": "));


                write(s, string'("Succes for test input: "));
            else
                write(s, lines_correct);
                write(s, string'(" / "));
                write(s, line_number + 1);
                write(s, string'(": "));

                write(s, string'("Error for test input: "));
            end if;

            write(s, reset);

            write(s, string'(" "));

            write(s, button_center);
            write(s, button_left);
            write(s, button_right);

            write(s, string'(" "));
            write(s, counter);

            write(s, string'(" (output = "));
            write(s, display_data);

            write(s, string'(" "));

            write(s, display_mask);
            write(s, string'(", desired output = "));
            write(s, desired_display_data);

            write(s, string'(" "));

            write(s, desired_display_mask);
            write(s, string'(")"));

            writeline(output, s);
        end if;
    end process;
end gedrag;

