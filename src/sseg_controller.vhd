
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity sseg_controller is
port(
    clk    : in std_logic;
    dig_en : in std_logic_vector(3 downto 0);
    dp_en  : in std_logic_vector(3 downto 0);
    num    : in integer range 0 to 9999;

    an  : out std_logic_vector(3 downto 0);
    cat : out std_logic_vector(7 downto 0));
end sseg_controller;

architecture behavioral of sseg_controller is
    signal dig_sel  : integer range 0 to 3;
    signal an_sel   : std_logic_vector(3 downto 0);
    signal cat_data : std_logic_vector(6 downto 0);

    component sseg_decoder
    port(
        clk     : in std_logic;
        num     : in integer range 0 to 9999;
        dig_sel : in integer range 0 to 3;

        an_sel   : out std_logic_vector(3 downto 0);
        cat_data : out std_logic_vector(6 downto 0));
    end component;
begin

    dig_counter : process( clk )
    begin
        if rising_edge(clk) then
            if (dig_sel = 3) then
                dig_sel <= 0;
            else
                dig_sel <= dig_sel + 1;
            end if;
        end if;
    end process;

    u1 : sseg_decoder
    port map(
        clk      => clk,
        num      => num,
        dig_sel  => dig_sel,
        an_sel   => an_sel,
        cat_data => cat_data
    );

    an <= not (dig_en and an_sel);

    cat(7) <= not dp_en(dig_sel);

    cat(6 downto 0) <= (not cat_data) when (dig_en(dig_sel) = '1') else "1111111";

end behavioral;
