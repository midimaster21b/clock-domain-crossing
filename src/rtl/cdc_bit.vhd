library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cdc_bit is
  generic (
    NUM_FF_G : integer range 4 to 10 := 4
    );
  port (
    src_clk_in    : in  std_logic;
    dest_clk_in   : in  std_logic;

    src_data_in   : in  std_logic;
    dest_data_out : out std_logic
    );
end cdc_bit;


architecture rtl of cdc_bit is

  signal src_cdc_data_r  : std_logic;
  signal ff_data_r       : std_logic_vector(NUM_FF_G-1 downto 0) := (others => '0');
  signal dest_cdc_data_r : std_logic;

begin

  dest_data_out <= dest_cdc_data_r;

  process(src_clk_in)
  begin
    if(rising_edge(src_clk_in)) then
      src_cdc_data_r   <= src_data_in;
    end if;
  end process;

  process(dest_clk_in)
  begin
    if(rising_edge(dest_clk_in)) then
      ff_data_r       <= ff_data_r(ff_data_r'left-1 downto ff_data_r'right) & src_cdc_data_r;
      dest_cdc_data_r <= ff_data_r(NUM_FF_G-1);
    end if;
  end process;
end rtl;
