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
  -- === Sinais internos (O "teu" código começa aqui) ===
  signal s_shifted_src : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_mask        : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_msfb_mask   : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0);
  signal s_msb_field   : std_logic;
  signal s_fill_bit    : std_logic;
  signal s_shift_fill : std_logic; -- Novo sinal interno
  
  constant N_BITS : integer := 2**DATA_BITS_LOG2;
begin

  -- Para o crédito extra (missing_bits_behaviour = 1), 
  -- o shift deve ser sempre aritmético se o bit 15 for 1.
  s_shift_fill <= src(N_BITS-1); 

  shifter: entity work.barrel_shift_right(behavioral)
    generic map (DATA_BITS_LOG2 => DATA_BITS_LOG2)
    port map (
      data_in  => src,
      data_out => s_shifted_src,
      shift    => start,
      missing  => s_shift_fill
    );

  -- 2. Máscaras: Geradas com base no 'size'
  -- Geração da máscara de validade (sem usar comparador externo)
  gen_masks: for i in 0 to N_BITS-1 generate
    -- O bit i pertence ao campo se i <= size
    s_mask(i) <= '1' when (i <= to_integer(unsigned(size))) else '0';
    
    -- O bit i é o MSB do campo se i == size
    s_msfb_mask(i) <= '1' when (i = to_integer(unsigned(size))) else '0';
  end generate;

  -- 3. Extracção do bit de sinal (MSB do campo recortado) [cite: 148, 151]
  s_msb_field <= or (s_shifted_src and s_msfb_mask);

  -- 4. Lógica de preenchimento (Zero extension vs Sign extension)
  s_fill_bit <= s_msb_field when variant = '1' else '0';

  -- 5. Seleção Final para cada bit do destino
  gen_out: for i in 0 to N_BITS-1 generate
    dst(i) <= s_shifted_src(i) when s_mask(i) = '1' else s_fill_bit;
  end generate;

end structural;