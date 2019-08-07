library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SPI_master is
port (clk_in  : in std_logic;
		miso	  : in std_logic;
		mosi	  : out std_logic;
		clk_out : out std_logic;
		ss		  : out std_logic);
end entity SPI_master;

architecture rtl of SPI_master is
begin
end architecture rtl;