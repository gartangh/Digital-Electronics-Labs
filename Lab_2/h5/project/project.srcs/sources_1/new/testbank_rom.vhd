library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

entity testbank_rom is
    end testbank_rom;

architecture gedrag of testbank_rom is
    -- testbank interne signalen
    file file_VECTORS : text;

    signal clk, reset, button, pressed, desired: std_logic := '0';

    signal tb_done, run : std_logic := '0';

    signal line_number : integer := 0;
    signal lines_correct : integer := 0;

    constant periode: time := 10ns;
begin
    DUT : entity work.button_pressed(gedrag)
    port map (
                 clk => clk,
                 reset => reset,
                 data_in => button,
                 data_out => pressed
             );

    -- hoofdproces dat instaat voor starten en stoppen
    process
    begin
        file_open(file_VECTORS, "input_vectors.txt",  read_mode);

        run <='0';
        wait for periode;

        run <= '1';
        wait until (tb_done = '1');

        run <= '0';
        wait for periode;

        file_close(file_VECTORS);

        report "Simulation ended"
        severity failure;
    end process;

    -- klokgenerator
    process(run, clk)
    begin
        if run='0' then
            clk <= '0';
        else
            clk <= not clk after periode;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Proces dat het bestand inleest en de gelezen data doorschrijft naar
    -- de juiste signalen
    -- Merk op dat lijnen met een # commentaarlijnen zijn.
    -- deze worden genegeerd, maar nemen wel een klokcyclus in beslag.
    ---------------------------------------------------------------------------
    process(clk)
        variable v_ILINE     : line;
        variable TEXT_INPUTS : std_logic_vector(1 downto 0);
        variable TEXT_OUTPUTS: std_logic;
        variable v_SPACE     : character;
    begin
        if rising_edge(clk) then
            if endfile(file_VECTORS) then
                tb_done <= '1';
            else
                line_number <= line_number + 1;

                tb_done <= '0';

                readline(file_VECTORS, v_ILINE);

                if (v_ILINE(1) = '#') then
                    writeline(output,v_ILINE);
                else
                    read(v_ILINE, TEXT_INPUTS);
                    read(v_ILINE, v_SPACE);           -- read in the space character
                    read(v_ILINE, TEXT_OUTPUTS);
                    reset <= TEXT_INPUTS(1);
                    button <= TEXT_INPUTS(0);
                    desired <= TEXT_OUTPUTS;
                end if;
            end if;
        end if;
    end process;

    -- controleproces
    process(clk)
        variable s: line;
    begin
        if rising_edge(clk) then
            write(s,string'("Line: "));
            write(s,line_number);
            write(s,string'(" "));

            if (pressed = desired) then
                lines_correct <= lines_correct + 1;

                write(s,string'("Succes for test input: "));
                write(s,reset);
                write(s,button);
                write(s,string'(" (output="));
                write(s,pressed);
                write(s,string'(", desired output="));
                write(s,desired);
                write(s,string'(")"));
            else
                write(s,string'("Error for test input: "));
                write(s,reset);
                write(s,button);
                write(s,string'(" (output="));
                write(s,pressed);
                write(s,string'(", desired output="));
                write(s,desired);
                write(s,string'(")"));
            end if;
            writeline(output,s);
        end if;
    end process;
end gedrag;

