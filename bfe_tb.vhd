--
-- AAD 2025/2026, bfe testbench
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bfe_tb is
end bfe_tb;

architecture stimulus of bfe_tb is
  -- constants
  constant DATA_BITS_LOG2 : positive := 4;
  -- the interface signals
  signal s_dst            : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_src            : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_size           : std_logic_vector(   DATA_BITS_LOG2-1 downto 0);
  signal s_start          : std_logic_vector(   DATA_BITS_LOG2-1 downto 0);
  signal s_variant        : std_logic;
  -- internal testbench siganls (to verify the correctness of the uut)
  signal s_expected       : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
begin
  uut : entity work.bfe(structural)
               generic map
               (
                 DATA_BITS_LOG2 => DATA_BITS_LOG2
               )
               port map
               (
                 dst     => s_dst,
                 src     => s_src,
                 size    => s_size,
                 start   => s_start,
                 variant => s_variant
               );
  stim : process is
  begin
    --- new test case
    s_src      <= "0110100101100101";
    s_size     <= "0101"; -- 5
    s_start    <= "0011"; -- 3
    s_variant  <= '0';
    s_expected <= "0000000000101100";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111101100";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "0110100101100101";
    s_size     <= "0100"; -- 4
    s_start    <= "1101"; -- 13
    s_variant  <= '0';
    s_expected <= "0000000000000011";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "0000000000000011";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "1111111111111111";
    s_size     <= "0101"; -- 5
    s_start    <= "0011"; -- 3
    s_variant  <= '0';
    s_expected <= "0000000000111111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111111111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "1111111111111111";
    s_size     <= "0100"; -- 4
    s_start    <= "1101"; -- 13
    s_variant  <= '0';
    s_expected <= "0000000000011111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111111111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "1000000000000000";
    s_size     <= "0100"; -- 4
    s_start    <= "1101"; -- 13
    s_variant  <= '0';
    s_expected <= "0000000000011100";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111111100";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "0000000000000001";
    s_size     <= "0000"; -- 0
    s_start    <= "0000"; -- 0
    s_variant  <= '0';
    s_expected <= "0000000000000001";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111111111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "1000000000000000";
    s_size     <= "0001"; -- 1
    s_start    <= "1111"; -- 15
    s_variant  <= '0';
    s_expected <= "0000000000000011";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "1111111111111111";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    --- new test case
    s_src      <= "0000000000000001";
    s_size     <= "1111"; -- 15
    s_start    <= "0000"; -- 0
    s_variant  <= '0';
    s_expected <= "0000000000000001";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    s_variant  <= '1';
    s_expected <= "0000000000000001";
    wait for 499 ps;
    assert s_dst = s_expected report "bad dst" severity note;
    wait for 1 ps;
    -- wait for ever
    wait;
  end process;
end stimulus;
