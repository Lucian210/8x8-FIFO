----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2021 11:11:04 AM
-- Design Name: 
-- Module Name: fifo_8x8 - Behavioral
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

entity fifo_8x8 is
   port(
      clk, rst:in std_logic; 
      rdinc, wrinc:in std_logic;
      DataIn:in std_logic_vector(7 downto 0);
      DataOut:out std_logic_vector(7 downto 0);
      rden, wren:in std_logic
	);
end entity;

architecture Behavioral of fifo_8x8 is

type fifo_array is array(7 downto 0) of std_logic_vector(7 downto 0);  
signal fifo: fifo_array;
signal wrptr, rdptr: std_logic_vector(2 downto 0) := "000";
signal en: std_logic_vector(7 downto 0);
signal mux: std_logic_vector(7 downto 0);
		
begin


process (rst, clk)
    begin
    if rst = '1' then
        for i in 7 downto 0 loop
        fifo(i) <= (others => '0');
    end loop;
    elsif (clk'event and clk = '1') then
    if wren = '1' then
        for i in 7 downto 0 loop
        if en(i) = '1' then
            fifo(i) <= DataIn;
        else
            fifo(i) <= fifo(i);
        end if;
        end loop;
    end if;
    end if;
    end process;


process (rst, clk)
		begin
			if rst = '1' then
            rdptr <= (others => '0');
			elsif (clk'event and clk='1') then
                if rdinc = '1' then
                rdptr <= rdptr + "001";
                end if;
			end if;
		end process;


process (rst, clk)
		begin
			if rst = '1' then
            wrptr <= (others => '0');
			elsif (clk'event and clk='1') then
                if wrinc = '1' then
                wrptr <= wrptr + 1;
                end if;
			end if;
		end process;



with std_logic_vector(rdptr) select
    mux<=
         fifo(0) when "000",
         fifo(1) when "001",
         fifo(2) when "010",
         fifo(3) when "011",
         fifo(4) when "100",
         fifo(5) when "101",
         fifo(6) when "110",
		 fifo(7) when others;


with std_logic_vector(wrptr) select
	en <=
	    "00000001" when "000",
		"00000010" when "001",
		"00000100" when "010",
		"00001000" when "011",
		"00010000" when "100",
		"00100000" when "101",
		"01000000" when "110",
		"10000000" when others;


process (rden, mux)
		begin
		  if(rden = '1') then
		      DataOut <= mux;
		  else 
		      DataOut <= "00000000";
		  end if;    
        end process;
		
		
end Behavioral;

