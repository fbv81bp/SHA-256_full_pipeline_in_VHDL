--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity LUT5x32w2out is
    Port ( clock : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (31 downto 0);-- := x"12345678";
           reg0 : out STD_LOGIC_VECTOR (31 downto 0);
           reg1 : out STD_LOGIC_VECTOR (31 downto 0));
end LUT5x32w2out;

architecture Behavioral of LUT5x32w2out is

    type shiftRegT is array(4 downto 0) of std_logic_vector(31 downto 0);
    signal shiftReg : shiftRegT := (x"d0000000", x"d1000000", x"d2000000", x"d3000000", x"d4000000");
    signal reg0o, reg1o : std_logic_vector(31 downto 0) := x"00000000";

    --testing...
--    signal clock : std_logic := '0';
    
begin
    --testing...
--    process begin
--        wait for 5 ns;
--        clock <= not clock;
--    end process;


    proc : process(clock)
    begin
        if rising_edge(clock) then
            shiftReg <= shiftReg(3 downto 0) & data;
--            reg0o <= shiftReg(1);
--            reg1o <= shiftReg(4);
        end if;
    end process;
  
            reg0o <= shiftReg(2);
            reg1o <= shiftReg(4);

    reg0 <= reg0o;
    reg1 <= reg1o;

end Behavioral;
