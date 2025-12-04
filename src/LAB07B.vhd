----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:18 05/28/2024 
-- Design Name: 
-- Module Name:    EPS07_A - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EPS07B is
    Port ( CLK : in  STD_LOGIC;
           DELAY : in  STD_LOGIC_VECTOR (2 downto 0);
           LOAD : in  STD_LOGIC;
           FAST : out  STD_LOGIC;
           SHIFT_OUT : out  STD_LOGIC;
           SLOW : out  STD_LOGIC);
end EPS07B;

architecture Behavioral of EPS07B is
-- Internal signals here:
signal SLOW_FREQ : integer range 0 to 32 := 0;
signal SLOW_OUT : std_logic := '0';


begin
process(CLK)
begin

if CLK'event then

    if CLK = '1' then
        if SLOW_FREQ < 15 then                              --- for creating SLOW signal
            SLOW_OUT = '1';
            SLOW_FREQ <= SLOW_FREQ + 1;
        elsif SLOW_FREQ >= 15 and SLOW_FREQ < 31 then
            SLOW_OUT = '0';
            SLOW_FREQ <= SLOW_FREQ + 1;
        else
            SLOW_FREQ <= 0;
        end if;
    end if;

    if FAST_FREQ < 3 then
        FAST_OUT = '1';
        FAST_FREQ <= FAST_FREQ + 1; 
    elsif FAST_FREQ >= 3 and FAST_FREQ < 7 then
        FAST_OUT = '0';
        FAST_FREQ <= FAST_FREQ + 1;
    else
        FAST_FREQ <= 0;
    end if;
    











end if;     --- CLK end
end Behavioral;

