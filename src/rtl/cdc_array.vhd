library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cdc_array is
  generic (
    NUM_FF_G   : integer range 4 to 10 := 4;
    NUM_BITS_G : integer := 1
    );
  port(
    src_clk_in    : in  std_logic;
    dest_clk_in   : in  std_logic;

    src_data_in   : in  std_logic_vector(NUM_BITS_G-1 downto 0);
    dest_data_out : out std_logic_vector(NUM_BITS_G-1 downto 0)
    );
end cdc_array;


architecture rtl of cdc_array is
begin

  cdc_bit_gen: for bit_i in 0 to NUM_BITS_G-1 generate
    u_cdc_bit: entity work.cdc_bit(rtl)
      generic map (
        NUM_FF_G => NUM_FF_G
        )
    port map (
      src_clk_in    => src_clk_in,
      dest_clk_in   => dest_clk_in,

      src_data_in   => src_data_in(bit_i),
      dest_data_out => dest_data_out(bit_i)
      );

  end generate;

end rtl;
