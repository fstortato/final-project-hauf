-------------------------------------------------------------------------------
-- Title      : Test Bench 7-Segment time division multiplexer
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : tdm_tb.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-16
-- Last update: 2021-01-16
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Test bench for the design of 7-Segment time division multiplexer
-- system design 1 practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-26  1.0      desf	  Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity tdm_tb is
end tdm_tb;
 
architecture behavioural of tdm_tb is 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	component tdm
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
	end component;

	--Inputs
	signal clk : std_logic := '1';
	signal reset : std_logic := '1';
	signal ld1 : std_logic_vector(7 downto 0) := (others => '0');
	signal ld2 : std_logic_vector(7 downto 0) := (others => '0');
	signal ld3 : std_logic_vector(7 downto 0) := (others => '0');
	signal ld4 : std_logic_vector(7 downto 0) := (others => '0');

	--Outputs
	signal ld_out: std_logic_vector(7 downto 0);
	signal a_out: std_logic_vector(3 downto 0);

   
	-- Clock period definitions
   constant CLK_PERIOD : time := 10 ns;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
	uut: tdm 
		generic map (ACTIVE_CYCLES => 50)
		port map (
			clk => clk,
			reset => reset,
			ld1 => ld1,
			ld2 => ld2,
			ld3 => ld3,
			ld4 => ld4,
			ld_out => ld_out,
			a_out => a_out -- a3 a2 a1 a0
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
      -- wait for 50 ns;
		
		-- wait for 5 ns; -- add phase between clock and signals
		
		-- change input values
		ld1 <= "00000001";
		ld2 <= "00000010";
		ld3 <= "00000011";
		ld4 <= "00000100";
		
		-- check if output updates
		
      wait;
   end process;

END;
