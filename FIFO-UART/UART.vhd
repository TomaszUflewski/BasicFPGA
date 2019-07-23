library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
	generic (
		clk_per_bit : integer := 1042 --set this to clk_f_Hz/baud_rate 10000000/9600 = 1041.6...
	);
	port(
		clk 		: in std_logic;

		rx 		: in std_logic;
		rx_done	: out std_logic;

		tx 		: out std_logic;
		tx_en 	: in std_logic;
		tx_ready	: out std_logic;

		rx_data_buffer : out std_logic_vector(7 downto 0);
		tx_data_buffer	: in  std_logic_vector(7 downto 0)
	);
end entity UART;

architecture rtl of UART is
	type tx_state is (tx_idle,
							tx_start,
							tx_data,
							tx_stop,
							tx_clean);
	signal s_tx_state : tx_state := tx_idle;

	type rx_state is (rx_idle,
							rx_start,
							rx_data,
							rx_stop,
							rx_clean);
	signal s_rx_state : rx_state := rx_idle;

   signal rx_cnt_clk 		: integer range 0 to clk_per_bit-1 := 0;
   signal tx_cnt_clk 		: integer range 0 to clk_per_bit-1 := 0;
   signal rx_cnt_cur_bit 	: integer range 0 to 7 := 0;
	signal tx_cnt_cur_bit 	: integer range 0 to 7 := 0;

	signal recv_data 	 : std_logic_vector(7 downto 0) := (others => '0');
	signal data_for_tx : std_logic_vector(7 downto 0) := (others => '0');

	signal tx_done : std_logic := '0';
	signal s_rx_done : std_logic := '0';

begin

recieve : process(clk)
begin
	if (rising_edge(clk)) then
		case s_rx_state is

			when rx_idle =>
				s_rx_done <= '0';
				rx_cnt_cur_bit <= 0;
				rx_cnt_clk <= 0;
				if (rx = '0') then
					s_rx_state <= rx_start;
				else
					s_rx_state <= rx_idle;
				end if;

			when rx_start =>
				if (rx_cnt_clk = (clk_per_bit-1)/2) then
					if (rx = '0') then
						s_rx_state <= rx_data;
						rx_cnt_clk <= 0;
					else
						s_rx_state <= rx_idle;
					end if;
				else
					rx_cnt_clk <= rx_cnt_clk + 1;
					s_rx_state <= rx_start;
				end if;
				s_rx_done <= '0';

			when rx_data =>
				if rx_cnt_clk < (clk_per_bit-1) then
					rx_cnt_clk <= rx_cnt_clk + 1;
					s_rx_state <= rx_data;
				else
					rx_cnt_clk <= 0;
					recv_data(rx_cnt_cur_bit) <= rx;

					if rx_cnt_cur_bit = 7 then
						s_rx_state <= rx_stop;
						rx_cnt_cur_bit <= 0;
					else
						s_rx_state <= rx_data;
						rx_cnt_cur_bit <= rx_cnt_cur_bit + 1;
					end if;
				end if;
				s_rx_done <= '0';

			when rx_stop =>
				if rx_cnt_clk < (clk_per_bit-1) then
					rx_cnt_clk <= rx_cnt_clk + 1;
					s_rx_state <= rx_stop;
					s_rx_done <= '0';
				else
					s_rx_state <= rx_clean;
					rx_cnt_clk <= 0;
					s_rx_done <= '1';
				end if;

			when rx_clean =>
				s_rx_done <= '0';
				rx_cnt_clk <= 0;
				rx_cnt_cur_bit <= 0;
				s_rx_state <= rx_idle;

		end case;
	end if;

	rx_data_buffer <= recv_data;
	rx_done <= s_rx_done;

end process recieve;

transmit : process (clk)
begin
	if (rising_edge(clk)) then
		case s_tx_state is

			when tx_idle =>
				if tx_en = '1' then
					s_tx_state <= tx_start;
					tx_cnt_clk <= 0;
					tx_cnt_cur_bit <= 0;
					tx_done <= '0';
					data_for_tx <= tx_data_buffer;
				else
					s_tx_state <= tx_idle;
					tx <= '1';
					tx_done <= '1';
				end if;

			when tx_start =>
				tx <= '0';
				if tx_cnt_clk < clk_per_bit-1 then
					tx_cnt_clk <= tx_cnt_clk + 1;
					s_tx_state <= tx_start;
				else
					s_tx_state <= tx_data;
					tx_cnt_clk <= 0;
				end if;
				tx_done <= '0';


			when tx_data =>
				tx <= data_for_tx(tx_cnt_cur_bit);
				if tx_cnt_clk < clk_per_bit-1 then
					tx_cnt_clk <= tx_cnt_clk + 1;
					s_tx_state <= tx_data;
				else
					tx_cnt_clk <= 0;
					if tx_cnt_cur_bit < 7 then
						tx_cnt_cur_bit <= tx_cnt_cur_bit + 1;
						s_tx_state <= tx_data;
					else
						s_tx_state <= tx_stop;
						tx_cnt_cur_bit <= 0;
					end if;
				end if;
				tx_done <= '0';

			when tx_stop =>
				tx <= '1';
				if tx_cnt_clk = clk_per_bit-1 then
					s_tx_state <= tx_clean;
					tx_cnt_clk <= 0;
				else
					tx_cnt_clk <= tx_cnt_clk + 1;
					s_tx_state <= tx_stop;
				end if;
				tx_done <= '0';

			when tx_clean =>
				s_tx_state <= tx_idle;
				tx_cnt_clk <= 0;
				tx_cnt_cur_bit <= 0;
				tx_done <= '1';

		end case;
	end if;

	tx_ready <= tx_done;

end process transmit;

end architecture rtl;
