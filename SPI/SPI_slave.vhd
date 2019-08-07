library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SPI_slave is
port (clk_in  : in std_logic;
		miso	  : out std_logic;
		mosi	  : in std_logic;
		ss		  : in std_logic);
end entity SPI_slave;

architecture rtl of SPI_slave is
begin
end architecture rtl;