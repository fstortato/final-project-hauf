-------------------------------------------------------------------------------
-- Title      : Stop watch top level
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : SW.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-11
-- Last update: 2021-01-11
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Entity for top level of stop watch design for system design 1
-- practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-09  1.0      desf    Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SW is
	generic(
		CLK_FREQ : integer := 20_000_000;
		BT_ACTIVE_STATE : std_logic := '1';
		BT_DEBOUNCE_CYCLES : integer := 20_000
	);
	port (
   clk      : in  std_logic;
   reset    : in  std_logic;
   key1     : in  std_logic;
   key2     : in  std_logic;
   -- sseg1   : out std_logic_vector(7 downto 0); -- removed from the entity to make it usable with the multiplexer
   -- sseg2   : out std_logic_vector(7 downto 0);
   -- sseg3   : out std_logic_vector(7 downto 0);
   -- sseg4   : out std_logic_vector(7 downto 0));
	sseg	   : out std_logic_vector(7 downto 0);
	sseg_sel : out std_logic_vector(3 downto 0)
	);
end SW;

architecture structural of SW is

	component stopwatch
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
	end component;
	
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
	
	component decoder
		port(
			hex: in std_logic_vector(3 downto 0);
			sseg: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component tdm
		generic(
			ACTIVE_CYCLES: integer := 70_000
			);
		port(
			reset: in std_logic;
			clk: in std_logic;
			ld1: in std_logic_vector(7 downto 0);
			ld2: in std_logic_vector(7 downto 0);
			ld3: in std_logic_vector(7 downto 0);
			ld4: in std_logic_vector(7 downto 0);
			ld_out: out std_logic_vector(7 downto 0);
			a_out: out std_logic_vector(3 downto 0) 
			);
	end component;
		
	signal key1_db : std_logic;
	signal key2_db : std_logic;
	signal hex1_s : std_logic_vector(3 downto 0);
	signal hex2_s : std_logic_vector(3 downto 0);
	signal hex3_s : std_logic_vector(3 downto 0);
	signal hex4_s : std_logic_vector(3 downto 0);
	signal sseg1_s : std_logic_vector(7 downto 0);
	signal sseg2_s : std_logic_vector(7 downto 0);
	signal sseg3_s : std_logic_vector(7 downto 0);
	signal sseg4_s : std_logic_vector(7 downto 0);
		
begin

	bt_db1: debounce
		generic map(DEBOUNCE_CYCLES => BT_DEBOUNCE_CYCLES, ACTIVE_STATE => BT_ACTIVE_STATE)
		port map(clk => clk, reset => reset, button_in => key1, button_deb => key1_db);
		
	bt_db2: debounce
		generic map(DEBOUNCE_CYCLES => BT_DEBOUNCE_CYCLES, ACTIVE_STATE => BT_ACTIVE_STATE)
		port map(clk => clk, reset => reset, button_in => key2, button_deb => key2_db);

	controller: stopwatch
		generic map(CLK_FREQ => CLK_FREQ, BT_ACTIVE_STATE => BT_ACTIVE_STATE)
		port map(clk => clk, reset => reset, key1 => key1_db, key2 => key2_db, hex1 => hex1_s, hex2 => hex2_s, hex3 => hex3_s, hex4 => hex4_s);
	
	decoder1: decoder
		port map(hex => hex1_s, sseg => sseg1_s);
		
	decoder2: decoder
		port map(hex => hex2_s, sseg => sseg2_s);
		
	decoder3: decoder
		port map(hex => hex3_s, sseg => sseg3_s);
		
	decoder4: decoder
		port map(hex => hex4_s, sseg => sseg4_s);
	
	time_multiplexer: tdm
		port map(clk => clk, reset => reset, ld1 => sseg1_s, ld2 => sseg2_s, ld3 => sseg3_s, ld4 => sseg4_s, ld_out => sseg, a_out => sseg_sel);
	
end structural;
