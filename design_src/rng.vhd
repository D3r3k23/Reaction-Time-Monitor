
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity rng is
port(
    clk    : in  std_logic;
    rst    : in  std_logic;
    update : in  std_logic;
    rand   : out integer range 1 to 10);
end rng;

architecture behavioral of rng is
    signal count : integer range 0 to 65000;
begin
    counter : process( clk )
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    rng : process( update )
    begin
        if (update = '1') then
            rand <= (count mod 10) + 1; -- 1 to 10
        end if;
    end process;
end behavioral;
