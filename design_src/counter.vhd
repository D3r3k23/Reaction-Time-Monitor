
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity counter is
port(
    clk : in  std_logic;
    rst : in  std_logic;
    en  : in  std_logic;
    count_o : out integer range 0 to 9999);
end counter;

architecture behavioral of stopwatch_counter is
    signal count : integer range 0 to 9999;
begin
    count_o <= count;

    process( clk )
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                count <= 0;
            elsif (en = '1') then
                if (count = 9999) then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            else
                count <= count;
            end if;
        end if;
    end process;
end behavioral;
