library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ha is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           sum : out STD_LOGIC;
           carry : out STD_LOGIC);
end ha;

architecture Behavioral of ha is

begin
sum <= a xor b;
carry <= a and b;

end Behavioral;
