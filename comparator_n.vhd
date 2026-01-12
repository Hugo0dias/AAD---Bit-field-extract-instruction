--
-- AAD 2025/2026, n-bit comparator
--
-- for extra credit, implement this also using chains of unsigned comparators:
--
-- unsigned comparator stage (one per bit)
--   in   a_bit   b_bit   old_lt   old_eq   old_gt
--   out                  new_lt   new_eq   new_gt
-- logic, start from the least significant bit with old_lt=old_gt=0 and old_eq=1
--   if a_bit=b_bit (no change, keep the earlier result)
--     new_lt=old_lt   new_eq=old_eq   new_gt=old_gt
--   else if a_bit=1 (a is greater because a_bit=1 and b_bit=0)
--     new_lt=0        new_eq=0        new_gt=1
--   else  (a is smaller because a_bit=0 and b_bit=1)
--     new_lt=1        new_eq=0        new_gt=0
-- use a transport delay of 5 ps per stage
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator_n is
  generic
  (
    N : positive
  );
  port
  (
    a  : in  std_logic_vector(N-1 downto 0);
    b  : in  std_logic_vector(N-1 downto 0);
    lt : out std_logic; -- '1' if a<b, '0' otherwise
    eq : out std_logic; -- '1' if a=b, '0' otherwise
    gt : out std_logic  -- '1' if a>b, '0' otherwise
  );
end comparator_n;

architecture behavioral of comparator_n is
  signal s_lt : std_logic;
  signal s_eq : std_logic;
  signal s_gt : std_logic;
begin
  s_lt <= '1' when unsigned(a) < unsigned(b) else '0';
  s_eq <= '1' when          a  =          b  else '0';
  s_gt <= '1' when unsigned(a) > unsigned(b) else '0';
  lt <= transport s_lt after (10+2*N)*ps;
  eq <= transport s_eq after (10    )*ps; -- smaller time penalty because comparison for equality is simpler
  gt <= transport s_gt after (10+2*N)*ps;
end behavioral;
