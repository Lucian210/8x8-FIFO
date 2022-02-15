----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2021 08:44:16 PM
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
	port ( clk, rst : in std_logic;
		    data : in std_logic_vector (15 downto 0);
		    sseg : out std_logic_vector (6 downto 0);
		    an : out std_logic_vector (3 downto 0));
end display;

architecture Behavioral of display is
	component hex2sseg is
    	port ( hex : in std_logic_vector (3 downto 0);
           	 sseg : out std_logic_vector (6 downto 0));
	end component hex2sseg;
	
	signal ledsel : std_logic_vector (1 downto 0);
	signal cntdiv : std_logic_vector (1 downto 0):= "00";
	signal segdata : std_logic_vector (3 downto 0);
	
begin
	process (clk, rst)
	begin
		if rst = '1' then
			cntdiv <= (others => '0');
		elsif (clk'event and clk = '1') then
			cntdiv <= cntdiv + '1';
		end if;
	end process;
	
	ledsel <= cntdiv(1 downto 0);
	
	an <= "1110" when ledsel = "00" else
		   "1101" when ledsel = "01" else
		   "1011" when ledsel = "10" else
		   "0111" when ledsel = "11";
			
	segdata <= data (3 downto 0)   when ledsel = "00" else
		        data (7 downto 4)   when ledsel = "01" else
		        data (11 downto 8)  when ledsel = "10" else
		        data (15 downto 12) when ledsel = "11";
				  
	hex2sseg_u: hex2sseg
		port map (hex => segdata, sseg => sseg);
		
end Behavioral;
