----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2021 08:43:12 PM
-- Design Name: 
-- Module Name: full - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full is
  Port ( 
        data_in:in std_logic_vector(7 downto 0);
        btn_rd, btn_wr : in std_logic;
        clk, rst: in std_logic;
        sseg:out std_logic_vector(6 downto 0);
        an:out std_logic_vector(3 downto 0);
        empty, full: out std_logic
        );
end full;

architecture Behavioral of full is

component fifo_ctrl is
  Port (
        rd, wr, rst, clk :in std_logic;
        rdinc, wrinc, empty, full :out std_logic
        );
end component;

component debouncer is
  Port ( 
        d_in:in std_logic;
        q_out:out std_logic;
        clk:in std_logic;
        rst:in std_logic
        );
end component;


component fifo_8x8 is
   port(
      clk, rst:in std_logic; 
      rdinc, wrinc:in std_logic;
      DataIn:in std_logic_vector(7 downto 0);
      DataOut:out std_logic_vector(7 downto 0);
      rden, wren:in std_logic
	);
end component;

component display is
	port ( clk, rst : in std_logic;
		    data : in std_logic_vector (15 downto 0);
		    sseg : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (3 downto 0));
end component;

signal rdsig, wrsig, rdincsig, wrincsig:std_logic;
signal data_outsig : std_logic_vector(7 downto 0);
signal data_display: std_logic_vector(15 downto 0);
begin

deb1: debouncer port map(btn_rd, rdsig, clk, rst);
deb2: debouncer port map(btn_wr, wrsig, clk, rst);
cntrl: fifo_ctrl port map(rdsig, wrsig, rst, clk, rdincsig, wrincsig, empty, full);
fifo: fifo_8x8 port map(clk, rst, rdincsig, wrincsig, data_in, data_outsig, rdsig, wrsig);
data_display(15 downto 8) <= data_in;
data_display(7 downto 0) <= data_outsig;
disp: display port map(clk, rst, data_display, sseg, an);

end Behavioral;
