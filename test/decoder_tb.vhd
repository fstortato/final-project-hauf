-------------------------------------------------------------------------------
-- Title      : 7-segment decoder Testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : decoder_tb.vhd
-- Author     : Marcel Putsche  <...@hrz.tu-chemnitz.de>
-- Company    : TU-Chemmnitz, SSE
-- Created    : 2014-08-18
-- Last update: 2014-08-18
-- Platform   : x86_64-redhat-linux
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 TU-Chemmnitz, SSE
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-08-18  1.0      mput    Created
-------------------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity decoder_tb is

end decoder_tb;

-------------------------------------------------------------------------------

architecture test of decoder_tb is

  component decoder
    port (
      hex  : in  std_logic_vector(3 downto 0);
      sseg : out std_logic_vector(7 downto 0));
  end component;

  -- component ports
  signal hex  : std_logic_vector(3 downto 0);
  signal sseg : std_logic_vector(7 downto 0);

  

begin  -- test

  -- component instantiation
  DUT : decoder
    port map (
      hex  => hex,
      sseg => sseg);

  
  WaveGen_Proc : process
  begin
    for i in 0 to 15 loop
      hex <= std_logic_vector(to_unsigned(i, 4));
      wait for 20 ns;
    end loop;
    wait;
  end process WaveGen_Proc;

  

end test;

-------------------------------------------------------------------------------

configuration decoder_tb_test_cfg of decoder_tb is
  for test
  end for;
end decoder_tb_test_cfg;

-------------------------------------------------------------------------------
