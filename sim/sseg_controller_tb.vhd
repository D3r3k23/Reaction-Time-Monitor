
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity sseg_controller_tb is
end sseg_controller_tb;

architecture test of sseg_controller_tb is
    component sseg_controller
    port(
        clk    : in std_logic;
        dig_en : in std_logic_vector(3 downto 0);
        dp_en  : in std_logic_vector(3 downto 0);
        num    : in integer range 0 to 9999;

        an  : out std_logic_vector(3 downto 0);
        cat : out std_logic_vector(7 downto 0));
    end component;

    signal clk : std_logic := '0';
    signal num : integer range 0 to 9999;

    signal an  : std_logic_vector(3 downto 0);
    signal cat : std_logic_vector(7 downto 0);

    constant half_period : time := 50 ns;
begin
    eut : sseg_controller
    port map(
        clk    => clk,
        dig_en => "1111",
        dp_en  => "1010",
        num    => num,
        an     => an,
        cat    => cat
    );

    clk <= not clk after half_period;

    process begin
        num <= 1234;
        wait for 10 ms;
    end process;
end test;
