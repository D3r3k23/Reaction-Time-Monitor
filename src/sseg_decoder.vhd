
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity sseg_decoder is
port(
    clk     : in std_logic;
    num     : in integer range 0 to 9999;
    dig_sel : in integer range 0 to 3;

    an_sel   : out std_logic_vector(3 downto 0);
    cat_data : out std_logic_vector(6 downto 0));
end sseg_decoder;

architecture behavioral of sseg_decoder is
begin
    cat_decoder : process( dig_sel, num )
        variable dig_data : integer range 0 to 9;
    begin
        case dig_sel is
            when    0 => dig_data := (num / 1) mod 10;
            when    1 => dig_data := (num / 10) mod 10;
            when    2 => dig_data := (num / 100) mod 10;
            when    3 => dig_data := (num / 1000) mod 10;
          when others => dig_data := 0;
        end case;

        case dig_data is
            when    0 => cat_data <= "0111111";
            when    1 => cat_data <= "0000110";
            when    2 => cat_data <= "1011011";
            when    3 => cat_data <= "1001111";
            when    4 => cat_data <= "1100110";
            when    5 => cat_data <= "1101101";
            when    6 => cat_data <= "1111101";
            when    7 => cat_data <= "0000111";
            when    8 => cat_data <= "1111111";
            when    9 => cat_data <= "1100111";
          when others => cat_data <= "0000000";
        end case;
    end process;

    an_decoder : process( dig_sel )
    begin
        case dig_sel is
            when    0 => an_sel <= "0001";
            when    1 => an_sel <= "0010";
            when    2 => an_sel <= "0100";
            when    3 => an_sel <= "1000";
          when others => an_sel <= "0000";
        end case;
    end process;

end behavioral;
