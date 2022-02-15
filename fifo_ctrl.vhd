----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/07/2021 08:45:44 PM
-- Design Name: 
-- Module Name: fifo_ctrl - Behavioral
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

entity fifo_ctrl is
  Port (
        rd, wr, rst, clk :in std_logic;
        rdinc, wrinc, empty, full :out std_logic
        );
end fifo_ctrl;



architecture Behavioral of fifo_ctrl is

signal cnter :std_logic_vector(3 downto 0) := "0000";

begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(rd = '1') then
            if(cnter > "0000") then
                rdinc<=rd;
                wrinc<='0';
                cnter <= cnter - "0001";
             end if;
        elsif(wr = '1') then
             if(cnter < "1000") then
                wrinc<=wr;
                rdinc<='0';
                cnter <= cnter + "0001";
             end if;
         else
                rdinc<='0';
                wrinc<='0';
        end if;
        
          if(rst = '1') then
             cnter <="0000";
        end if;
    end if;
    
     if(cnter = "1000") then 
           full <= '1';
           empty <= '0';
           wrinc <= '0';
       elsif (cnter = "0000") then
           full <= '0';
           empty <= '1';
           rdinc <= '0';
       else
           full <= '0';
           empty <= '0';
       end if;
       
end process;




end Behavioral;
