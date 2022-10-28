library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.vcomponents.all;

use std.env.finish;

entity cdc_bit_tb is
end cdc_bit_tb;

architecture sim of cdc_bit_tb is
  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------
  constant NUM_DATA_CHANGES_C    : integer := 5;

  constant CLK_25_PERIOD_C       : time    := 40 ns; -- 25 MHz
  constant CLK_125_PERIOD_C      : time    := 8 ns;  -- 125 MHz

  constant SRC_CLK_PERIOD_C      : time    := CLK_125_PERIOD_C;
  constant DEST_CLK_PERIOD_C     : time    := CLK_25_PERIOD_C;


  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal src_clk_s   : std_logic := '0';
  signal dest_clk_s  : std_logic := '0';

  signal src_data_r  : std_logic := '0';
  signal dest_data_r : std_logic;

  signal test_pass_r : std_logic := '0';

begin

  src_clk_s  <= not src_clk_s  after SRC_CLK_PERIOD_C/2;
  dest_clk_s <= not dest_clk_s after DEST_CLK_PERIOD_C/2;


  process
  begin
    for i in 0 to NUM_DATA_CHANGES_C-1 loop
      wait for 2*CLK_25_PERIOD_C;
      src_data_r <= not src_data_r;
      wait until src_data_r = dest_data_r;

      report "Data change " & integer'image(i) & " successful.";
    end loop;

    test_pass_r <= '1';
    wait;
  end process;


  process
  begin
    wait for 100 us;
    if(test_pass_r = '1') then
      report "Test complete: PASS";

    else
      report "Test complete: FAIL";

    end if;
    finish;
  end process;


  u_dut: entity work.cdc_bit(rtl)
    generic map (
      NUM_FF_G => 4
      )
    port map (
      src_clk_in    => src_clk_s,
      dest_clk_in   => dest_clk_s,

      src_data_in   => src_data_r,
      dest_data_out => dest_data_r
      );

end sim;
