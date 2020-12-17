
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity rtm_wrapper is
port(
    clk_100M : in std_logic;
    btn      : in std_logic_vector(3 downto 0);

    led      : out std_logic_vector(0 downto 0);
    sseg_an  : out std_logic_vector(3 downto 0);
    sseg_cat : out std_logic_vector(7 downto 0));
end rtm_wrapper;

architecture behavioral of rtm_wrapper is
    signal clk_1k    : std_logic;
    signal clk_5k    : std_logic;
    signal sseg_en   : std_logic;
    signal sseg_en_d : std_logic_vector(3 downto 0);
    signal num       : integer range 0 to 9999;

    component clk_divider
    generic(
        DIV : integer);
    port(
        clk_in  : in  std_logic;
        clk_out : out std_logic);
    end component;

    component rtm
    port(
        clk   : in std_logic;
        rst   : in std_logic;
        start : in std_logic;
        react : in std_logic;

        react_now : out std_logic;
        sseg_en   : out std_logic;
        num_o     : out integer range 0 to 9999);
    end component;

    component sseg_controller
    port(
        clk    : in std_logic;
        dig_en : in std_logic_vector(3 downto 0);
        dp_en  : in std_logic_vector(3 downto 0);
        num    : in integer range 0 to 9999;

        an  : out std_logic_vector(3 downto 0);
        cat : out std_logic_vector(7 downto 0));
    end component;
begin

    rtm_clk : clk_divider
    generic map(
        DIV => 100000
    )port map(
        clk_in  => clk_100M,
        clk_out => clk_1k
    );

    sseg_clk : clk_divider
    generic map(
        DIV => 20000
    )port map(
        clk_in  => clk_100M,
        clk_out => clk_5k
    );

    u1 : rtm
    port map(
        clk       => clk_1k,
        rst       => btn(0),
        start     => btn(2),
        react     => btn(3),
        react_now => led(0),
        sseg_en   => sseg_en,
        num_o     => num
    );

    sseg_en_d <= (sseg_en & sseg_en & sseg_en & sseg_en);

    u2 : sseg_controller
    port map(
        clk    => clk_5k,
        dig_en => sseg_en_d,
        dp_en  => "1000",
        num    => num,
        an     => sseg_an,
        cat    => sseg_cat
    );

end behavioral;
