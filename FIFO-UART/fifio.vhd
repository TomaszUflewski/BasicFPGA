library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity FIFO is
	generic (
		fifo_width : natural := 8;
		fifo_depth : natural := 3
	);
	port (
		clk : in std_logic;
		
		in_data 		: in std_logic_vector(fifo_width-1  downto 0);
	   enable_in 	: in std_logic;
		
		out_data		: out std_logic_vector(fifo_width-1 downto 0);
		enable_out	: in std_logic;
		
		empty 		: out std_logic;
		full			: out std_logic
	);
end entity FIFO;

architecture rtl of FIFO is
	type fifo_data_type is array (0 to fifo_depth - 1) of std_logic_vector(fifo_width-1 downto 0);
	signal fifo_data	: fifo_data_type := (others => (others => '0'));
	
	signal wrd_cnt 	: integer range -1 to fifo_depth+1 := 0;
	
	signal r_idx 		: integer range 0 to fifo_depth - 1 := 0;
	signal w_idx 		: integer range 0 to fifo_depth - 1 := 0;
	
	signal s_full 		: std_logic := '0';
	signal s_empty 	: std_logic := '1';
	
begin
	
fifo_ctrl : process(clk) is
begin
	if rising_edge(clk) then
		
		if enable_in = '1' then
			fifo_data(w_idx) <= in_data;
		end if;
	
		--no need to change wrd_cnt if both read and write are eabled
		if enable_in = '1' and enable_out = '0' then -- add data
			wrd_cnt <= wrd_cnt + 1;
		end if;
		if enable_in = '0' and enable_out = '1' then --read
			wrd_cnt <= wrd_cnt - 1;
		end if;
		
		if enable_in = '1' then
			if w_idx = fifo_depth-1 then --need to star agin
				w_idx <= 0;
			else -- inc
				w_idx <= w_idx + 1;
			end if;
		end if;

		if enable_out = '1' then
			if r_idx = fifo_depth-1 then
				r_idx <= 0;
			else
				r_idx <= r_idx + 1;
			end if;
		end if;
		
		
		
	end if;
end process fifo_ctrl;
	out_data <= fifo_data(r_idx);
	
	--update control signals
	s_empty <= '1' when wrd_cnt = 0 else '0';
	s_full  <= '1' when wrd_cnt = fifo_depth else '0';
	empty <= s_empty;
	full 	<= s_full;
	
end architecture rtl;
