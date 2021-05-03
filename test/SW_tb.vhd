-------------------------------------------------------------------------------
-- Title      : Test Bench Stopwatch
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : SW_tb.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-16
-- Last update: 2021-01-16
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Test bench for the design of the stop watch for
-- system design 1 practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-09  1.0      desf	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity SW_tb is
end SW_tb;
 
architecture behavioural of SW_tb is 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	component SW
		generic(
			CLK_FREQ : integer := 20_000_000;
			BT_ACTIVE_STATE : std_logic := '1';
			BT_DEBOUNCE_CYCLES : integer := 20_000
			);
		port (
			clk     : in  std_logic;
			reset   : in  std_logic;
			key1    : in  std_logic;
			key2    : in  std_logic;
			sseg	   : out std_logic_vector(7 downto 0);
			sseg_sel : out std_logic_vector(3 downto 0)
			);
	end component;

	--Inputs
	signal reset : std_logic := '1';
	signal clk : std_logic := '0';
	signal key1 : std_logic := '0';
	signal key2 : std_logic := '0';


	--Outputs
	signal sseg : std_logic_vector(7 downto 0);
	signal sseg_sel : std_logic_vector(3 downto 0);
   
	-- Clock period definitions
   constant CLK_PERIOD : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
	uut: SW 
		generic map (CLK_FREQ => 5, BT_ACTIVE_STATE => '1', BT_DEBOUNCE_CYCLES => 5)
		port map (
			clk => clk,
			reset => reset,
			key1 => key1,
			key2 => key2,
			sseg => sseg,
			sseg_sel => sseg_sel		
			);

   -- Clock definition
   clk <= NOT clk after CLK_PERIOD/2;
 

   -- Stimulus process
   stim_process: process
   begin		
      -- hold reset state for 50 ns (5 clock cycles)
		reset <= '0';
      wait for 50 ns;	

		reset <= '1';
      wait for 50 ns;
		
		 wait for 5 ns;
		
		-- press start/pause button (sufficient amount of time)
		key1 <= '1';
		wait for 100 ns;
		key1 <= '0';
		
		wait for 1000 ns; -- check if indicators of seconds are increasing

		
		-- press start/pause button
		key1 <= '1';
		wait for 100 ns;
		key1 <= '0';
		
		wait for 200 ns; -- check if paused
		
		
		-- press clear button
		key2 <= '1';
		wait for 100 ns;
		key2 <= '0';
		
		wait for 200 ns; -- check if cleared and paused
		
		
		-- press start/pause button
		key1 <= '1';
		wait for 100 ns;
		key1 <= '0';
		
		wait for 185_000 ns;

		
		-- press clear button
		key2 <= '1';
		wait for 100 ns;
		key2 <= '0';
		
		wait for 500 ns; -- check if cleared and the stopwatch continues

		-- press start/pause button
		key1 <= '1';
		wait for 100 ns;
		key1 <= '0';

		
		wait for 500 ns; -- check if paused
		
		
		-- press start/pause button
		key1 <= '1';
		wait for 100 ns;
		key1 <= '0';
		
		
		wait for 500 ns; -- check if counting
		
		reset <= '0';  -- check reset
      wait for 50 ns;	

		reset <= '1';
		
      wait;
   end process;

END;
