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

entity EPS07_A is
    Port ( CLK : in  STD_LOGIC;
           DIG_DELAY : in  STD_LOGIC_VECTOR (3 downto 0);
           LOAD : in  STD_LOGIC;
           CLK_L : out  STD_LOGIC;
           CLK_SF : out  STD_LOGIC);
end EPS07_A;

architecture Behavioral of EPS07_A is
-- signals here:
signal L_FREQ, SF_FREQ : integer range 0 to 15 := 0;	         -- for counting the frequency of CLK_L
signal L_OUT, SF_OUT : std_logic;										-- output for CLK_L
signal DELAY, DELAY_SAVE : integer range 0 to 15 := 0;			-- integer range of delay (shift)

begin
process(CLK)
begin

if CLK'event and CLK = '1' then								-- clock

	if L_FREQ < 7 then											-- half 1 for CLK_16
		L_OUT <= '1';	
		L_FREQ <= L_FREQ + 1;
	elsif (L_FREQ < 15) and (L_FREQ >= 7) then				-- half 0 for CLK_16
		L_OUT <= '0';
		L_FREQ <= L_FREQ + 1;
	else
		L_FREQ <= 0;						-- reaching for 16 clock cycle
	end if;

	if LOAD = '1' then						-- change the delay of shift if load activated	
		DELAY <= conv_integer(DIG_DELAY);	-- saving delay input amount for delay count
		DELAY_SAVE <= DELAY;					-- saving delay amount
	end if;
	
	if DELAY = 0 then						-- for arranging the OUT_SF DELAY
		if SF_FREQ < 7 then				-- for giving the OUT_SF with 1/16 freq of CLK
			SF_OUT <= '1';
			SF_FREQ <= SF_FREQ + 1;
		elsif (SF_FREQ >= 7) and (SF_FREQ < 15) then
			SF_OUT <= '1';
			SF_FREQ <= SF_FREQ + 1;
		else
			SF_FREQ <= 0;
			DELAY <= DELAY_SAVE;
		end if;
	else
		DELAY <= DELAY - 1;
	end if;
	
end if;				-- clock end if
end process;

CLK_L <= L_OUT;
CLK_SF <= SF_OUT;

end Behavioral;

