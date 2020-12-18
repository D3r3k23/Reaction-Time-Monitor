
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity stopwatch_counter is
port(
    clk   : in  std_logic;
    rst   : in  std_logic;
    en    : in  std_logic;
    val_o : out integer range 0 to 9999);
end stopwatch_counter;

architecture behavioral of stopwatch_counter is
    signal val : integer range 0 to 9999;
begin
    val_o <= val;

    process( clk )
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                val <= 0;
            elsif (en = '1') then
                if (val = 9999) then
                    val <= 0;
                else
                    val <= val + 1;
                end if;
            else
                val <= val;
            end if;
        end if;
    end process;
end behavioral;
