library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_drv is --resolution 800x600
generic (
	constant hDisplay : integer := 800;
	constant hFP		: integer := 40;
	constant hBP  		: integer := 88;
	constant hSyncP   : integer := 128;
	
	constant vDisplay : integer := 600;
	constant vFP		: integer := 1;
	constant vBP		: integer := 23;
	constant vSyncT   : integer := 4;
	
	constant h_sync_polarity : std_logic := '1';
	constant v_sync_polarity : std_logic := '1'
	
);
port (
	clk : in std_logic;
	v, h : inout std_logic;
	vga_en : out std_logic;
	x,y : out std_logic_vector (10 downto 0)
);
end vga_drv;


architecture bevahioral of vga_drv is
	constant v_total : integer := vDisplay + vFP + vBP + vSyncT;
	constant h_total : integer := hDisplay + hFP + hBP + hSyncP;
	
	signal v_cnt : integer := 0;
	signal h_cnt : integer := 0;
begin

proc_v_cnt: process (h)
begin
	if rising_edge(h) then
		if v_cnt < v_total then
			v_cnt <= v_cnt + 1;
		else 
			v_cnt <= 0;
		end if;
	end if;
end process;

proc_h_cnt: process (clk)
begin
	if rising_edge(clk) then
		if h_cnt < h_total then
			h_cnt <= h_cnt + 1;
		else 
			h_cnt <= 0;
		end if;
	end if;
end process;

h_sync: process (clk)
begin
	if rising_edge(clk) then
		if h_cnt < hDisplay + hFP or h_cnt >= hDisplay + hFP + hSyncP then
			h <= h_sync_polarity;
		else
			h <= not h_sync_polarity;
		end if;
	end if;
end process;

v_sync: process (h)
begin
	if h'event and h = h_sync_polarity then
		if v_cnt < vDisplay + vFP or v_cnt >= vDisplay + vFP + vSyncT then
			v <= v_sync_polarity;
		else
			v <= not v_sync_polarity;
		end if;
	end if;
end process;


draw: process (clk)
begin
	if rising_edge(clk) then
		if v_cnt < vDisplay and h_cnt < hDisplay then
				vga_en <= '1';
			else
				vga_en <= '0';
		end if;
		x <= std_logic_vector(to_unsigned(h_cnt, x'length));
		y <= std_logic_vector(to_unsigned(v_cnt, y'length));
	end if;
end process;

end bevahioral;