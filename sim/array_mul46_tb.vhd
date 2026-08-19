library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity array_mul46 is
   
end array_mul46;

architecture Behavioral of array_mul46 is

component bit_mul_46 is
    Port ( a : in STD_LOGIC_VECTOR (5 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
          p : out STD_LOGIC_VECTOR (9 downto 0));
end component;
signal a1:STD_LOGIC_VECTOR (5 downto 0);
signal b:STD_LOGIC_VECTOR (3 downto 0) ;
signal mul:STD_LOGIC_VECTOR (9 downto 0);

begin
call:bit_mul_46 port map (a1,b,mul);

process 
begin
a1<="000000"; b<="0001"; wait for 10ns;
a1<="000001"; b<="0001"; wait for 10ns;
a1<="000001"; b<="0011"; wait for 10ns;
a1<="000011"; b<="0011"; wait for 10ns;
a1<="111111"; b<="1111"; wait for 10ns;
a1<="011111"; b<="1001"; wait for 10ns;
a1<="011110"; b<="1101"; wait for 10ns;

end process;

end Behavioral;

  
