library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vga_display is
port (
	clk 		: in std_logic;
	x, y 		: in std_logic_vector (10 downto 0);
	vga_en 	: in std_logic;
	pixel 	: out std_logic_vector(2 downto 0)
);
end vga_display; 

architecture rtl of vga_display is
	signal clk_en : std_logic := '0';
	signal cnt : integer := 0;
	signal s_pixel : std_logic_vector(2 downto 0) := (others => '0');
begin

draw : process(clk)
begin
	if rising_edge(clk)  then
		if vga_en = '1' then
		
			if to_integer(unsigned(x)) mod 3 = 0 then
				s_pixel <= ("100");
			elsif to_integer(unsigned(x)) mod 5 = 0 then
				s_pixel <= ("010");
			else
				s_pixel <= ("001");
			end if;
			
	   end if;
	end if;
end process draw;

pixel <= s_pixel when vga_en = '1'  else (others => '0');

end architecture rtl;