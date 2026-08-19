library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_mul_46 is
    Port ( a : in STD_LOGIC_VECTOR (5 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           p : out STD_LOGIC_VECTOR (9 downto 0));
end bit_mul_46;

architecture Behavioral of bit_mul_46 is
    component ha is
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               sum : out STD_LOGIC;
               carry : out STD_LOGIC);
    end component;

    component fa is
        Port ( a : in STD_LOGIC;
               b : in STD_LOGIC;
               c : in STD_LOGIC;
               sum : out STD_LOGIC;
               carry : out STD_LOGIC);
    end component;
    
    -- Array for partial products: 4 rows (b bits) x 6 columns (a bits)
    type partial_array is array (0 to 3) of STD_LOGIC_VECTOR(5 downto 0);
    signal r : partial_array;
    
    -- Intermediate sum and carry signals
    signal s : STD_LOGIC_VECTOR(1 to 10);  -- 10 intermediate sum signals
    signal c : STD_LOGIC_VECTOR(1 to 17);  -- 17 intermediate carry signals
    
begin
    
    -- =========================================================================
    -- STAGE 1: Generate all partial products (AND gates)
    -- =========================================================================
    gen_partial_products: for i in 0 to 3 generate  -- For each b bit (4 bits)
        gen_bits: for j in 0 to 5 generate         -- For each a bit (6 bits)
            r(i)(j) <= a(j) and b(i);  -- AND operation: a_bit * b_bit
        end generate gen_bits;
    end generate gen_partial_products;
    
    -- =========================================================================
    -- STAGE 2: First row of adders (process r0 and r1)
    -- =========================================================================
    
    -- p0 is directly from first partial product
    p(0) <= r(0)(0);
    
    -- First half adder: r0(1) + r1(0)
    ha_row1_0: ha port map(
        a => r(0)(1),      -- from first partial product row
        b => r(1)(0),      -- from second partial product row  
        sum => p(1),       -- goes to output bit 1
        carry => c(1)      -- carry to next adder
    );
    
    -- Generate full adders for middle bits (4 adders)
    gen_row1_middle: for i in 1 to 4 generate
        fa_row1: fa port map(
            a => r(0)(i+1),  -- from first row, next column
            b => r(1)(i),    -- from second row, same column
            c => c(i),       -- carry from previous adder
            sum => s(i),     -- intermediate sum
            carry => c(i+1)  -- carry to next adder
        );
    end generate gen_row1_middle;
    
    -- Last half adder in first row
    ha_row1_last: ha port map(
        a => r(1)(5),      -- last bit of second row
        b => c(5),         -- carry from previous adder
        sum => s(5),       -- intermediate sum
        carry => c(6)      -- final carry of first row
    );
    
    -- =========================================================================
    -- STAGE 3: Second row of adders (process r2 and intermediate sums)
    -- =========================================================================
    
    -- First half adder in second row
    ha_row2_0: ha port map(
        a => r(2)(0),      -- from third partial product row
        b => s(1),         -- sum from first row
        sum => p(2),       -- goes to output bit 2
        carry => c(7)      -- carry to next adder
    );
    
    -- Generate full adders for middle bits (4 adders)
    gen_row2_middle: for i in 1 to 4 generate
        fa_row2: fa port map(
            a => r(2)(i),      -- from third row
            b => s(i+1),       -- sum from first row (next column)
            c => c(6+i),       -- carry from previous adder (c7, c8, c9, c10)
            sum => s(5+i),     -- intermediate sum (s6, s7, s8, s9)
            carry => c(7+i)    -- carry to next adder (c8, c9, c10, c11)
        );
    end generate gen_row2_middle;
    
    -- Last full adder in second row
    fa_row2_last: fa port map(
        a => r(2)(5),      -- last bit of third row
        b => c(6),         -- carry from first row
        c => c(11),        -- carry from previous adder
        sum => s(10),      -- intermediate sum
        carry => c(12)     -- carry to next stage
    );
    
    -- =========================================================================
    -- STAGE 4: Third row of adders (process r3 and final sums)
    -- =========================================================================
    
    -- First half adder in third row
    ha_row3_0: ha port map(
        a => r(3)(0),      -- from fourth partial product row
        b => s(6),         -- sum from second row
        sum => p(3),       -- goes to output bit 3
        carry => c(13)     -- carry to next adder
    );
    
    -- Generate full adders for output bits 4-7 (4 adders)
    gen_row3_output: for i in 1 to 4 generate
        fa_row3: fa port map(
            a => r(3)(i),      -- from fourth row
            b => s(6+i),       -- sum from second row (s7, s8, s9, s10)
            c => c(12+i),      -- carry from previous adder (c13, c14, c15, c16)
            sum => p(3+i),     -- direct output (p4, p5, p6, p7)
            carry => c(13+i)   -- carry to next adder (c14, c15, c16, c17)
        );
    end generate gen_row3_output;
    
    -- Final full adder for last two bits
    fa_final: fa port map(
        a => r(3)(5),      -- last bit of fourth row
        b => c(12),        -- carry from second row
        c => c(17),        -- carry from previous adder
        sum => p(8),       -- output bit 8
        carry => p(9)      -- output bit 9 (MSB)
    );
    
end Behavioral;
