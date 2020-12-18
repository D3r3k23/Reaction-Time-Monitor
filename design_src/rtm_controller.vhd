
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity rtm_controller is
port(
    clk   : in std_logic;
    rst   : in std_logic;
    start : in std_logic;
    react : in std_logic;
    num   : in integer range 0 to 9999;
    rand  : in integer range 1 to 10;
    
    update_rand : out std_logic;
    count_en    : out std_logic;
    count_rst   : out std_logic;
    react_now   : out std_logic;
    sseg_en     : out std_logic);
end rtm_controller;

architecture behavioral of rtm_controller is
    type state_t is ( s_INIT, s_IDLE, s_START_WAIT, s_WAIT, s_START_REACT, s_REACT, s_OVERFLOW );
    signal ps, ns : state_t;

    signal start_react : boolean;
    signal overflow    : boolean;
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

    start_react <= (num >= (rand * 1000));
    overflow    <= (num >= 9999);

    comb_logic : process( ps, rst, start, react, start_react, overflow )
    begin
        if (rst = '1') then
            ns <= s_INIT;
        else
            case ps is
                when s_INIT =>
                    count_en    <= '0';
                    count_rst   <= '1';
                    update_rand <= '0';
                    react_now   <= '0';
                    sseg_en     <= '0';

                    ns <= s_IDLE;

                when s_IDLE =>
                    count_en    <= '0';
                    count_rst   <= '0';
                    update_rand <= '0';
                    react_now   <= '0';
                    sseg_en     <= '1';

                    if (start = '1') then ns <= s_START_WAIT;
                    else                  ns <= s_IDLE;
                    end if;

                when s_START_WAIT =>
                    count_en    <= '0';
                    count_rst   <= '1';
                    update_rand <= '1';
                    react_now   <= '0';
                    sseg_en     <= '0';

                    ns <= s_WAIT;

                when s_WAIT =>
                    count_en    <= '1';
                    count_rst   <= '0';
                    update_rand <= '0';
                    react_now   <= '0';
                    sseg_en     <= '0';

                    if (start_react) then ns <= s_START_REACT;
                    else                  ns <= s_WAIT;
                    end if;

                when s_START_REACT =>
                    count_en    <= '0';
                    count_rst   <= '1';
                    update_rand <= '0';
                    react_now   <= '0';
                    sseg_en     <= '0';

                    if (react = '1') then ns <= s_START_REACT;
                    else                  ns <= s_REACT;
                    end if;

                when s_REACT =>
                    count_en    <= '1';
                    count_rst   <= '0';
                    update_rand <= '0';
                    react_now   <= '1';
                    sseg_en     <= '1';

                    if    (react = '1' ) then ns <= s_IDLE;
                    elsif (overflow    ) then ns <= s_OVERFLOW;
                    else                      ns <= s_REACT;
                    end if;

                when s_OVERFLOW =>
                    count_en    <= '0';
                    count_rst   <= '1';
                    update_rand <= '0';
                    react_now   <= '0';
                    sseg_en     <= '0';

                    ns <= s_IDLE;

                when others =>
                    ns <= s_INIT;
            end case;
        end if;
    end process;

end behavioral;
