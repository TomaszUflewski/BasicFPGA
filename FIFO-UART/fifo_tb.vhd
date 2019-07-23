library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FIFO_TB is
end FIFO_TB;



architecture behav of FIFO_TB is
signal dupa1 :  std_logic_vector(3 downto 0);
signal clk 		: std_logic := '0';
signal in_data 		: std_logic_vector(7  downto 0);
signal enable_in 	: std_logic;
		
signal out_data		: std_logic_vector(7 downto 0);
signal enable_out 	: std_logic; -- input
		
signal empty 		: std_logic; -- out if empty
signal full 		: std_logic;  -- out if full

constant clk_period : time := 200 ps;
begin

DUT : entity work.fifo(rtl)
	port map (dupa1,
	clk,
	in_data,
	enable_in,
	out_data,
	enable_out,
	empty,
	full);

clk <= not clk after clk_period/2;

process is 
begin
	enable_in <= '1';
	enable_out <= '0';


	in_data <= "00000000";
	wait until falling_edge(clk);
	assert empty = '0' report "Test failed - fifo is not empty!" severity failure;

	in_data <= "00000001";
	wait until rising_edge(clk);
	in_data <= "00000010";
	wait until rising_edge(clk);
	wait for 1 ps;
	assert full = '1' report "Test failed - fifo is not full!" severity failure;

	enable_in <= '0';
	enable_out <= '1';
	wait until rising_edge(clk);
	wait for 1 ps;
	assert out_data = "00000001" severity failure;
	wait until rising_edge(clk);
	wait for 1 ps;
	assert full = '0' severity failure;
	assert out_data = "00000010" severity failure;

	assert False report "Test passed" severity note;
end process;

end architecture behav;