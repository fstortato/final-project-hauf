-------------------------------------------------------------------------------
-- Title      : Test Bench Button Debounce
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : debounce_tb.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-16
-- Last update: 2021-01-16
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Test bench for the design of button debouce of
-- system design 1 practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-16  1.0      desf	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity debounce_tb is
end debounce_tb;
 
architecture behavioural of debounce_tb is 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	component debounce
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
	end component;

	--Inputs
	signal clk : std_logic := '1';
	signal reset : std_logic := '1';
	signal button_in : std_logic := '0';

	--Outputs
	signal button_deb : std_logic;

   
	-- Clock period definitions
   constant CLK_PERIOD : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
	uut: debounce 
		generic map (DEBOUNCE_CYCLES => 5)
		port map (
			clk => clk,
			reset => reset,
			button_in => button_in,
			button_deb => button_deb	
			);

   -- Clock definition
   clk <= NOT clk after CLK_PERIOD/2;
 

   -- Stimulus process
   stim_process: process
   begin		
      -- hold reset state for 500 ns (10 clock cycles)
		reset <= '0';
      wait for 50 ns;	

		reset <= '1';
      wait for 50 ns;
		
		wait for 5 ns; -- add phase between clock and signals
		
		-- press start/pause button
		button_in <= '1';
		wait for 20 ns; -- not enough time (test debounce)
		button_in <= '0';
		
		wait for 40 ns;
		
		button_in <= '1';
		
		wait for 55 ns; -- enough time
		button_in <= '0';
		
		
		wait for 10 ns;
		
		button_in <= '1';
		
		wait for 100 ns; -- enough time
		button_in <= '0';
		
		
      wait;
   end process;

END;
