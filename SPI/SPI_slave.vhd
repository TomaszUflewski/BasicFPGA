library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SPI_slave is
generic(
	WORD_SIZE : integer := 8);
port (clk_in  : in std_logic;
		miso	  : out std_logic;
		mosi	  : in std_logic;
		ss		  : in std_logic;
		
		clk	   : in std_logic;
		data_out : out std_logic_vector( WORD_SIZE-1 downto 0);
		data_out_rdy : std_logic);
end entity SPI_slave;

architecture rtl of SPI_slave is
	signal s_ss : std_logic := '1';
	
	signal s_recv_c 		: integer range 0 to WORD_SIZE-1;
	signal s_data_recv	: std_logic_vector(WORD_SIZE-1 downto 0);
begin

ss_update : process (ss) begin
	s_ss <= s;
end process ss_update;

recv : process (clk_in) begin

if rising_edge(clk_in) then
	if s_ss = '0' or s_recv_c = WORD_SIZE then
		if s_recv_c < WORD_SIZE then
			s_data_recv(s_recv_c) <= mosi;
			s_recv_c <= s_recv_c + 1;
			data_out_rdy <= '0';
		else
			data_out <= s_data_recv;
			data_out_rdy <= '1';
		end if;
	else
		data_out_rdy <= '0';
	end if; -- s_ss
end if; --clk_in

end process recv;


end architecture rtl;