-------------------------------------------------------------------------------
-- Title      : Stopwatch
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : stopwatch.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-09
-- Last update: 2021-01-09
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Given Entity for the main controller of the stop watch for
-- system design 1 practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-09  1.0      desf	  Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity stopwatch is
	generic(
		CLK_FREQ : integer := 20_000_000;
		BT_ACTIVE_STATE : std_logic := '1'
	);
	port(
		clk: in std_logic;								-- clock 20 MHz
		reset: in std_logic;
		key1: in std_logic;
		key2: in std_logic;
		hex1: out std_logic_vector(3 downto 0);	-- seconds
		hex2: out std_logic_vector(3 downto 0);   -- tens of seconds
		hex3: out std_logic_vector(3 downto 0);	-- minutes
		hex4: out std_logic_vector(3 downto 0)		-- tens of minutes
		);
end stopwatch;

architecture behavioural of stopwatch is

	constant MAX_TENS : integer := 5;
	constant MAX_UNITS : integer := 9;
	
	type state_type is (START_STATE, RUN_STATE, PAUSE_STATE, RESET_STATE);
	
	signal current_state : state_type;
	signal next_state : state_type;
	
	signal counter_seconds : unsigned(3 downto 0);
	signal counter_minutes : unsigned(3 downto 0);
	signal counter_tens_seconds : unsigned(3 downto 0);
	signal counter_tens_minutes : unsigned(3 downto 0);
	
	signal counter_cycles : integer range 0 to (CLK_FREQ - 1); 
	signal change : std_logic;
	
begin

-- Using 3 processes: transition, change output, state register
-- Debouncing of push-button needs to be implemented outside

	p_t: process (current_state, key1, key2, change) -- calculates next state
	begin
	
		case current_state is
		
			when START_STATE =>
				if (key1 = BT_ACTIVE_STATE) then next_state <= RUN_STATE;
				else next_state <= START_STATE;
				end if;
				
			when RUN_STATE =>
				if (key1 = BT_ACTIVE_STATE AND key2 = NOT(BT_ACTIVE_STATE)) then next_state <= PAUSE_STATE;
				elsif (key1 = NOT(BT_ACTIVE_STATE) AND key2 = BT_ACTIVE_STATE) then next_state <= RESET_STATE;
				else next_state <= RUN_STATE;
				end if;
			
			when PAUSE_STATE =>
				if (key1 = BT_ACTIVE_STATE AND key2 = NOT(BT_ACTIVE_STATE)) then next_state <= RUN_STATE;
				elsif (key1 = NOT(BT_ACTIVE_STATE) AND key2 = BT_ACTIVE_STATE) then next_state <= START_STATE;
				else next_state <= PAUSE_STATE;
				end if;
			
			when RESET_STATE =>
				next_state <= RUN_STATE;
				
			when others => next_state <= START_STATE; -- default
		
		end case;
	
	
	end process;
	
	p_o: process (current_state, clk) -- updates the output
	
	begin
	
		if(rising_edge(clk)) then
		
			case current_state is
		
				when START_STATE =>
				
					counter_cycles <= 0;
					counter_seconds <= (others => '0');
					counter_tens_seconds <= (others => '0');
					counter_minutes <= (others => '0');
					counter_tens_minutes <= (others => '0');
					
				when RUN_STATE =>
					
					if (counter_cycles = (CLK_FREQ - 1)) then 
						counter_cycles <= 0;
						
						if (counter_seconds < MAX_UNITS) then
							counter_seconds <= counter_seconds + 1; -- after "clock frequency" cycles, 1 second has passed: 1 Hz = 1 / s
						else
							counter_seconds <= (others => '0');
							if (counter_tens_seconds < MAX_TENS) then
								counter_tens_seconds <= counter_tens_seconds + 1;
							else
								counter_tens_seconds <= (others => '0');
								if (counter_minutes < MAX_UNITS) then
									counter_minutes <= counter_minutes + 1;
								else
									counter_minutes <= (others => '0');
									if (counter_tens_minutes < MAX_TENS) then
										counter_tens_minutes <= counter_tens_minutes + 1;
									else
										counter_tens_minutes <= (others => '0');
										counter_minutes <= (others => '0');
										counter_tens_seconds <= (others => '0');
										counter_seconds <= (others => '0');
									end if;
								
								end if;
							
							end if;
							
						end if;
					
					else counter_cycles <= counter_cycles + 1; -- add 1 more cycle to the counter
					
					end if;
			
					
				when RESET_STATE =>
					counter_cycles <= 0;
					counter_seconds <= (others => '0');
					counter_tens_seconds <= (others => '0');
					counter_minutes <= (others => '0');
					counter_tens_minutes <= (others => '0');
					
				when others => NULL; -- do nothing
			
			end case;
		
		end if;
		

	end process;
	
	hex1 <= std_logic_vector(counter_seconds);
	hex2 <= std_logic_vector(counter_tens_seconds);
	hex3 <= std_logic_vector(counter_minutes);
	hex4 <= std_logic_vector(counter_tens_minutes);
	
	p_s: process (clk, reset) -- updates state register
	begin
	
		if (reset = '0') then
			current_state <= START_STATE;
			change <= '0';
		elsif (clk'event and clk = '1') then
			current_state <= next_state;
			change <= NOT(change);
		end if;
				
	end process;
	

end behavioural;