-------------------------------------------------------------------------------
-- Title      : 7-Segment time division multiplexer
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : tdm.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-26
-- Last update: 2021-01-26
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Created Entity for 7-Segment multiplexer (light all four 7-seg displays)
-- practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-26  1.0      desf	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity tdm is
	generic(
		ACTIVE_CYCLES: integer := 70_000 -- @ 20 MHz is 3.5 ms active time per display 
		);
	port(
		reset: in std_logic;
		clk: in std_logic;
		ld1: in std_logic_vector(7 downto 0);
		ld2: in std_logic_vector(7 downto 0);
		ld3: in std_logic_vector(7 downto 0);
		ld4: in std_logic_vector(7 downto 0);
		ld_out: out std_logic_vector(7 downto 0);
		a_out: out std_logic_vector(3 downto 0) -- a3 a2 a1 a0
		);
end tdm;

architecture behavioural of tdm is

	type state_type is (STATE_RESET, STATE_LD1, STATE_LD2, STATE_LD3, STATE_LD4);
	
	signal count : integer range 0 to ACTIVE_CYCLES;
	signal current_state : state_type;
	signal next_state : state_type;
	signal change : std_logic;
	signal number_out : std_logic_vector(7 downto 0);
	signal sel_display : std_logic_vector(3 downto 0);
	
	
begin
	
	p_t: process (current_state, change, count)
	begin
	
			case current_state is
			
				when STATE_RESET =>
					next_state <= STATE_LD1;
			
				when STATE_LD1 =>
					if(count = ACTIVE_CYCLES) then
						next_state <= STATE_LD2;
					else
						next_state <= STATE_LD1;
					end if;
			
				when STATE_LD2 =>
					if(count = ACTIVE_CYCLES) then
						next_state <= STATE_LD3;
					else
						next_state <= STATE_LD2;
					end if;
					
				when STATE_LD3 =>
					if(count = ACTIVE_CYCLES) then
						next_state <= STATE_LD4;
					else
						next_state <= STATE_LD3;
					end if;
					
				when STATE_LD4 =>
					if(count = ACTIVE_CYCLES) then
						next_state <= STATE_LD1;
					else
						next_state <= STATE_LD4;
					end if;
					
				when others => next_state <= STATE_LD1; -- default
			
			end case;
	
	end process;
	
	
	p_o: process (current_state, clk, ld1, ld2, ld3, ld4, count) -- updates the output
	begin
	
		if(rising_edge(clk)) then
		

			if(count < ACTIVE_CYCLES) then 
				count <= count + 1;
			else 
				count <= 0;
			end if;
			
		end if;
		
		case current_state is
		
			when STATE_RESET =>
				count <= 0;
				number_out <= ld1;
				sel_display <= "1111";
	
			when STATE_LD1 =>
				number_out <= ld1;
				sel_display <= "0111";
		
			when STATE_LD2 =>
				number_out <= ld2;
				sel_display <= "1011";
			
			when STATE_LD3 =>
				number_out <= ld3;
				sel_display <= "1101";
		
			when STATE_LD4 =>
				number_out <= ld4;
				sel_display <= "1110";
		
			when others => 
			
				number_out <= ld1;
				sel_display <= "1111";
		
		end case;
		
		
	end process;
	
	ld_out <= number_out;
	a_out <= sel_display;

	
	p_s: process (clk, reset)
	begin
	
		if (reset = '0') then
			current_state <= STATE_RESET;
			change <= '0';
		elsif (clk'event AND clk = '1') then
			current_state <= next_state;
			change <= NOT(change);
		end if;
				
	end process;
end behavioural;
