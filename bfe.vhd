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

  signal s_shifted_src : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0); -- Barrel shifted deslocado start bits to the right
  signal s_mask        : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0); -- Máscara de validade do campo (0000000000111111 por exemplo)
  signal s_msfb_mask   : std_logic_vector(2**DATA_BITS_LOG2-1 downto 0); -- Máscara do MSB do campo (0000000000100000 por exemplo)
  signal s_msb_field   : std_logic; -- Bit de sinal do campo extraído
  signal s_fill_bit    : std_logic; -- Bit de preenchimento (0 ou bit de sinal)
  signal s_shift_fill : std_logic; -- Bit de preenchimento para o barril shift right
  
  constant N_BITS : integer := 2**DATA_BITS_LOG2;
begin

  -- Para o crédito extra (missing_bits_behaviour = 1), 
  -- o shift deve ser sempre aritmético se o bit 15 for 1.
  s_shift_fill <= src(N_BITS-1); -- MSB do src para o missing bits

  shifter: entity work.barrel_shift_right(behavioral)
    -- Mutliplexer de deslocamento à direita em barril
    generic map (DATA_BITS_LOG2 => DATA_BITS_LOG2) -- Define o tamanho do barril em tempo de compilação com Data_BITS_LOG2 camadas
    -- Mapeamento de portas do barril
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
    -- Mascara com bits '1' para os bits válidos do campo
    s_mask(i) <= '1' when (i <= to_integer(unsigned(size))) else '0';
    
    -- O bit i é o MSB do campo se i == size
    -- Mascara com um único bit '1' na posição do MSB do campo
    s_msfb_mask(i) <= '1' when (i = to_integer(unsigned(size))) else '0';
  end generate;

  -- 3. Extracção do bit de sinal (MSB do campo recortado) -> define a variante .s ou .u
  s_msb_field <= or (s_shifted_src and s_msfb_mask);

  -- 4. Lógica de preenchimento (Zero extension vs Sign extension)
  s_fill_bit <= s_msb_field when variant = '1' else '0';

  -- 5. Seleção Final para cada bit do destino
  gen_out: for i in 0 to N_BITS-1 generate
    dst(i) <= s_shifted_src(i) when s_mask(i) = '1' else s_fill_bit;
  end generate;

  -- Exemplo de uso do comparador n-bit (crédito extra)
  --   i   s_mask(i)  Condição           dst(i)
  -- 15    0       mask='0'  →  s_fill_bit = '1'
  -- 14    0       mask='0'  →  s_fill_bit = '1'
  -- 13    0       mask='0'  →  s_fill_bit = '1'
  -- ...
  -- 6     0       mask='0'  →  s_fill_bit = '1'
  -- 5     1       mask='1'  →  s_shifted_src(5) = '1'
  -- 4     1       mask='1'  →  s_shifted_src(4) = '0'
  -- 3     1       mask='1'  →  s_shifted_src(3) = '1'
  -- 2     1       mask='1'  →  s_shifted_src(2) = '1'
  -- 1     1       mask='1'  →  s_shifted_src(1) = '0'
  -- 0     1       mask='1'  →  s_shifted_src(0) = '0'

end structural;