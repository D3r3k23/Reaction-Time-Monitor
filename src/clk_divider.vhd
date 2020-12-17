
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity clk_divider is
generic(
    DIV : integer);
port(
    clk_in  : in  std_logic;
    clk_out : out std_logic);
end clk_divider;

architecture behavioral of clk_divider is
    constant TC    : integer := (DIV / 2) - 1;
    signal count   : integer := 0;
    signal div_clk : std_logic := '0';
begin
    clk_out <= div_clk;

    process( clk_in )
    begin
        if rising_edge(clk_in) then
            if (count = TC) then
                count <= 0;
                div_clk <= not div_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end behavioral;
