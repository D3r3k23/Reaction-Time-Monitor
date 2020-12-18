
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity rtm is
port(
    clk   : in std_logic;
    rst   : in std_logic;
    start : in std_logic;
    react : in std_logic;

    react_now : out std_logic;
    sseg_en   : out std_logic;
    num_o     : out integer range 0 to 9999);
end rtm;

architecture behavioral of rtm is
    signal sw_start : std_logic;
    signal sw_stop  : std_logic;

    signal count_en    : std_logic;
    signal count_rst   : std_logic;
    signal update_rand : std_logic;

    signal rand : integer range 1 to 10;
    signal num  : integer range 0 to 9999;

    component rng
    port(
        clk    : in  std_logic;
        rst    : in  std_logic;
        update : in  std_logic;
        rand   : out integer range 1 to 10);
    end component;

    component rtm_controller
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
    end component;

    component stopwatch
    port(
        clk   : in std_logic;
        rst   : in std_logic;
        start : in std_logic;
        stop  : in std_logic;
        inc   : in std_logic;
        clear : in std_logic;
        num   : out integer range 0 to 9999);
    end component;
begin

    num_o <= num;

    u1 : rng
    port map(
        clk    => clk,
        rst    => rst,
        update => update_rand,
        rand   => rand
    );

    u2 : rtm_controller
    port map(
        clk   => clk,
        rst   => rst,
        start => start,
        react => react,
        num   => num,
        rand  => rand,

        update_rand => update_rand,
        count_en    => count_en,
        count_rst   => count_rst,
        react_now   => react_now,
        sseg_en     => sseg_en
    );

    sw_start <= count_en;
    sw_stop  <= not count_en;

    u3 : stopwatch
    port map(
        clk   => clk,
        rst   => rst,
        start => sw_start,
        stop  => sw_stop,
        inc   => '0',
        clear => count_rst,
        num   => num
    );

end behavioral;
