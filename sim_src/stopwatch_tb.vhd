
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity stopwatch_tb is
end stopwatch_tb;

architecture test of stopwatch_tb is
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

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal start : std_logic;
    signal stop  : std_logic;
    signal inc   : std_logic;
    signal clear : std_logic;
    
    signal num   : integer range 0 to 9999;

    constant half_period : time := 50 ns;
begin
    eut : stopwatch
    port map(
        clk   => clk,
        rst   => rst,
        btn   => btn,
        start => start,
        stop  => stop,
        inc   => inc,
        clear => clear,
        num   => num
    );

    clk_10M <= not clk_10M after half_period;

    process begin
        
        rst <= '1';
        wait for 500 ns;

        rst <= '0';
        wait for 200 ns;

        start <= '1';
        wait for 1000 ns;

        start <= '0';
        wait for 1000 ns;

        stop <= '1';
        wait for 250 ns;

        stop <= '0';
        wait for 250 ns;

        inc <= '1';
        wait for 200 ns;

        inc <= '0';
        wait for 200 ns;

        inc <= '1';
        wait for 200 ns;

        inc <= '0';
        wait for 200 ns;

        clear <= '1';
        wait for 500 ns;

    end process;
end test;
