--
-- AAD 2025/2026, data flow for the bit-field extract instruction
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bfe is
  generic
  (
    DATA_BITS_LOG2 : integer range 2 to 6 := 4                    -- use 4 by default
  );
  port
  ( 
    dst     : out std_logic_vector(2**DATA_BITS_LOG2-1 downto 0); -- 15 downto 0
    src     : in  std_logic_vector(2**DATA_BITS_LOG2-1 downto 0); -- 15 downto 0
    size    : in  std_logic_vector(   DATA_BITS_LOG2-1 downto 0); --  3 downto 0
    start   : in  std_logic_vector(   DATA_BITS_LOG2-1 downto 0); --  3 downto 0
    variant : in  std_logic                                       -- '0' for .u and '1' for .s
  );
end bfe;

architecture structural of bfe is
  -- internal signals
begin
  -- instantiation of logic blocks, please provide in the report a block diagram of your implementation
end structural;
