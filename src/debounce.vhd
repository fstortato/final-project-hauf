-------------------------------------------------------------------------------
-- Title      : Button debounce
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : debounce.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-12
-- Last update: 2021-01-12
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Extra Entity for debouncing the buttons of the stop watch for
-- system design 1 practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-12  1.0      desf	  Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity debounce is
	generic(
		DEBOUNCE_CYCLES : integer := 20_000;
		ACTIVE_STATE : std_logic := '1'
		);
	port(
		clk: in std_logic;
		reset: in std_logic;
		button_in: in std_logic;
		button_deb: out std_logic
		);
end debounce;

architecture behavioural of debounce is

	type state_type is (START, IDLE, WAITING);
	
	signal count : integer range 0 to DEBOUNCE_CYCLES;
	signal current_state : state_type;
	signal next_state : state_type;
	signal deb : std_logic;
	signal change : std_logic;
	
	
begin
	
	
	
	p_t: process (current_state, button_in, count, change)
	begin
	
			case current_state is
			
				when START =>
					next_state <= IDLE;
			
				when IDLE =>
					if (button_in = ACTIVE_STATE) then
						next_state <= WAITING;
					else next_state <= IDLE;
					end if;
					
				when WAITING =>
					if (count = DEBOUNCE_CYCLES) then 
						if(button_in = NOT(ACTIVE_STATE)) then
							next_state <= IDLE;
						else
							next_state <= WAITING;
						end if;
				
					elsif (button_in = ACTIVE_STATE) then 
						next_state <= WAITING;
					
						
					else next_state <= IDLE;
					
					end if;
				
					
				when others => next_state <= START; -- default
			
			end case;
	
	end process;
	
	
	p_o: process (current_state, button_in, clk) -- updates the output
	begin
	
		if(rising_edge(clk)) then
	
			case current_state is
		
				when START =>
					count <= 0;
					deb <= NOT(ACTIVE_STATE);
			
				when IDLE =>
					deb <= NOT(ACTIVE_STATE);
					count <= 0;
					
				when WAITING =>
					if (count = DEBOUNCE_CYCLES) then 
						if(button_in = NOT(ACTIVE_STATE)) then
							deb <= ACTIVE_STATE;
							count <= 0;
						end if;
				
					elsif (button_in = ACTIVE_STATE) then count <= count + 1;
						
					end if;
				
					
				when others => 
					deb <= NOT(ACTIVE_STATE);
					count <= 0;
				
			end case;
			
		end if;

		
	end process;
	
	button_deb <= deb;
	
	
	p_s: process (clk, reset)
	begin
	
		if (reset = '0') then
			current_state <= START;
			change <= '0';
		elsif (clk'event AND clk = '1') then
			current_state <= next_state;
			change <= NOT(change);
		end if;
				
	end process;
	
end behavioural;