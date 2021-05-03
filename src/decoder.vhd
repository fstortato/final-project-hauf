-------------------------------------------------------------------------------
-- Title      : 7-Segment decoder
-- Project    : Stopwatch
-------------------------------------------------------------------------------
-- File       : decoder.vhd
-- Author     : Felipe Tortato
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2021-01-09
-- Last update: 2021-01-09
-- Platform   : x86_64-windows-10
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: Given Entity for 7-Segment decoder for the System design 1
-- practical lab
-------------------------------------------------------------------------------
-- Copyright (c) 2021 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-09  1.0      desf	Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decoder is
	port(
		hex: in std_logic_vector(3 downto 0);
		sseg: out std_logic_vector(7 downto 0)
		);
end decoder;

architecture behavioural of decoder is
begin

	-- "<dp><a><b><c><d><e><f><g>" and light is on with signal '0'
	with hex select
	sseg <= "10000001" when "0000", -- 0 abcdef
			  "11001111" when "0001", -- 1 bc
			  "10010010" when "0010", -- 2 abdeg
			  "10000110" when "0011", -- 3 abcdg
			  "11001100" when "0100", -- 4 bcfg
			  "10100100" when "0101", -- 5 acdfg
			  "10100000" when "0110", -- 6 acdefg
			  "10001111" when "0111", -- 7 abc
			  "10000000" when "1000", -- 8 abcdefg
			  "10000100" when "1001", -- 9 abcdfg
			  "11111111" when others; -- invalid number returns all off
end behavioural;