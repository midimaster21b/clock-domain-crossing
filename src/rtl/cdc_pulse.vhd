-- TODO: Add reset functionality

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cdc_pulse is
  port (
    src_clk_in    : in  std_logic;
    dest_clk_in   : in  std_logic;

    src_data_in   : in  std_logic;
    dest_data_out : out std_logic
    );
end cdc_pulse;


architecture rtl of cdc_pulse is
  constant NUM_DETECTION_BITS_C : integer := 3;
  constant MULTI_LEADING_EDGE_C : std_logic_vector(NUM_DETECTION_BITS_C-1 downto 0) := (NUM_DETECTION_BITS_C-1 => '0', others => '1');
  constant SINGLE_LEADING_EDGE_C : std_logic_vector(NUM_DETECTION_BITS_C-1 downto 0) := (0 => '1', others => '0');

  signal src_ff_r   : std_logic_vector(NUM_DETECTION_BITS_C-1 downto 0) := (others => '0');
  signal dest_ff_r  : std_logic_vector(NUM_DETECTION_BITS_C-1 downto 0) := (others => '0');
  signal clear_r    : std_logic_vector(NUM_DETECTION_BITS_C-1 downto 0) := (others => '0');

  signal detected_r : std_logic := '0';

  signal pulse_r    : std_logic := '0';


begin

  -- Output The pulse
  dest_data_out <= pulse_r;


  sample_in: process(src_clk_in)
  begin
    if(rising_edge(src_clk_in)) then
      src_ff_r(0) <= src_data_in;

      for i in 1 to src_ff_r'length-1 loop
        src_ff_r(i) <= src_ff_r(i-1);
      end loop;
    end if;
  end process;


  detect_in: process(src_clk_in)
  begin
    if(rising_edge(src_clk_in)) then
      -- If leading edge of ack detected
      if(clear_r = MULTI_LEADING_EDGE_C) then
        detected_r <= '0';

      -- If leading edge of input pulse
      elsif(src_ff_r = SINGLE_LEADING_EDGE_C) then
        detected_r <= '1';

      end if;
    end if;
  end process;


  detect_ack: process(src_clk_in)
  begin
    if(rising_edge(src_clk_in)) then
      clear_r <= clear_r(NUM_DETECTION_BITS_C-2 downto 0) & dest_ff_r(NUM_DETECTION_BITS_C-1);
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Destination clock domain
  -----------------------------------------------------------------------------
  -- Sample the detected pulse register
  sample_out: process(dest_clk_in)
  begin
    if(rising_edge(dest_clk_in)) then
      -- Shift in detected pulse value
      dest_ff_r <= dest_ff_r(NUM_DETECTION_BITS_C-2 downto 0) & detected_r;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- This process is responsible for outputting the detected pulse
  -----------------------------------------------------------------------------
  pulse_out: process(dest_clk_in)
  begin
    if(rising_edge(dest_clk_in)) then
      if(dest_ff_r = MULTI_LEADING_EDGE_C) then
        pulse_r <= '1';

      else
        pulse_r <= '0';

      end if;
    end if;
  end process;
end rtl;
