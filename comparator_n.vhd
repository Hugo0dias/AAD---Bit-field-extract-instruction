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
  generic ( N : integer := 4 );
  port (
    a, b : in  std_logic_vector(N-1 downto 0);
    lt   : out std_logic;
    eq   : out std_logic;
    gt   : out std_logic  -- Adicionado para resolver o erro do TB
  );
end comparator_n;

architecture behavioral of comparator_n is
  signal s_lt, s_eq, s_gt : std_logic_vector(N downto 0);
begin
  -- Condições iniciais no MSB (bit N)
  s_lt(N) <= '0';
  s_eq(N) <= '1';
  s_gt(N) <= '0';

  gen_comp: for i in N-1 downto 0 generate
    -- Lógica com atraso de transporte de 5ps conforme enunciado
    s_lt(i) <= (s_lt(i+1) or (s_eq(i+1) and (not a(i) and b(i)))) after 5 ps;
    s_eq(i) <= (s_eq(i+1) and (a(i) xnor b(i))) after 5 ps;
    s_gt(i) <= (s_gt(i+1) or (s_eq(i+1) and (a(i) and not b(i)))) after 5 ps;
  end generate;

  lt <= s_lt(0);
  eq <= s_eq(0);
  gt <= s_gt(0);
end behavioral;