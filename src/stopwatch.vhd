
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity stopwatch is
port(
    clk   : in std_logic;
    rst   : in std_logic;
    start : in std_logic;
    stop  : in std_logic;
    inc   : in std_logic;
    clear : in std_logic;
    num   : out integer range 0 to 9999);
end stopwatch;

architecture behavioral of stopwatch is
    signal counter_en  : std_logic;
    signal counter_rst : std_logic;

    component stopwatch_controller
    port(
        clk   : in std_logic;
        rst   : in std_logic;
        start : in std_logic;
        stop  : in std_logic;
        inc   : in std_logic;
        clear : in std_logic;

        counter_en  : out std_logic;
        counter_rst : out std_logic);
    end component;

    component stopwatch_counter
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;
        en    : in  std_logic;
        val_o : out integer range 0 to 9999);
    end component;
begin

    u1 : stopwatch_controller
    port map(
        clk   => clk,
        rst   => rst,
        start => start,
        stop  => stop,
        inc   => inc,
        clear => clear,

        counter_rst => counter_rst,
        counter_en  => counter_en
    );

    u2 : stopwatch_counter
    port map(
        clk   => clk,
        rst   => (counter_rst or rst),
        en    => counter_en,
        val_o => num
    );

end behavioral;
