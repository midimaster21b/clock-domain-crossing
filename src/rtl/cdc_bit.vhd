library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cdc_bit is
  generic (
    NUM_FF_G : integer range 4 to 10 := 4
    );
  port(
    src_clk_in    : in  std_logic;
    dest_clk_in   : in  std_logic;

    src_data_in   : in  std_logic;
    dest_data_out : out std_logic
    );
end cdc_bit;


architecture rtl of cdc_bit is

  signal dest_ff : std_logic_vector(NUM_FF_G-1 downto 0) := (others => '0');

begin

  dest_data_out <= dest_ff(NUM_FF_G-1);

  process(src_clk_in)
  begin
    if(rising_edge(src_clk_in)) then
      dest_ff(0) <= src_data_in;
      dest_ff(1) <= dest_ff(0);
    end if;
  end process;

  process(dest_clk_in)
  begin
    if(rising_edge(dest_clk_in)) then
      for ff_i in 2 to NUM_FF_G-1 loop
        dest_ff(ff_i) <= dest_ff(ff_i-1);
      end loop;
    end if;
  end process;
end rtl;
