
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity stopwatch_controller is
port(
    clk   : in std_logic;
    rst   : in std_logic;
    start : in std_logic;
    stop  : in std_logic;
    inc   : in std_logic;
    clear : in std_logic;
    
    counter_en  : out std_logic;
    counter_rst : out std_logic);
end stopwatch_controller;

architecture behavioral of stopwatch_controller is
    type state_t is (s_INIT, s_WAIT, s_COUNT, s_INC, s_INC_HOLD);
    signal ps, ns : state_t;
begin

    state_reg : process( clk )
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                ps <= s_INIT;
            else
                ps <= ns;
            end if;
        end if;
    end process;

    comb_logic : process( ps, rst, start, stop, inc, clear )
    begin
        if (rst = '1') then
            ns <= s_INIT;
        else
            case ps is
                when s_INIT =>
                    counter_en  <= '0';
                    counter_rst <= '1';

                    ns <= s_WAIT;

                when s_WAIT =>
                    counter_en  <= '0';
                    counter_rst <= '0';

                    if    (clear = '1') then ns <= s_INIT;
                    elsif (inc   = '1') then ns <= s_INC;
                    elsif (start = '1') then ns <= s_COUNT;
                    else                     ns <= s_WAIT;
                    end if;

                when s_COUNT =>
                    counter_en  <= '1';
                    counter_rst <= '0';

                    if    (clear = '1') then ns <= s_INIT;
                    elsif (stop  = '1') then ns <= s_WAIT;
                    else                     ns <= s_COUNT;
                    end if;

                when s_INC =>
                    counter_en  <= '1';
                    counter_rst <= '0';
                    
                    ns <= s_INC_HOLD;

                when s_INC_HOLD =>
                    counter_en  <= '0';
                    counter_rst <= '0';

                    if    (clear = '1') then ns <= s_INIT;
                    elsif (inc   = '0') then ns <= s_WAIT;
                    elsif (start = '1') then ns <= s_COUNT;
                    else                     ns <= s_INC_HOLD;
                    end if;

                when others =>
                    ns <= s_INIT;
            end case;
        end if;
    end process;

end behavioral;
