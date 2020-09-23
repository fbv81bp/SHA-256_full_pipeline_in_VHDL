--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_hw_test is
    Port ( clock : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);-- := "00000011";
           led : out STD_LOGIC_VECTOR (7 downto 0));
end sha256_hw_test;

architecture Behavioral of sha256_hw_test is

    component sha256_full_top is
        Port ( clock : in STD_LOGIC;
               pipeInit : in STD_LOGIC_VECTOR (255 downto 0);
               dataIn : in STD_LOGIC_VECTOR (511 downto 0);
               pipeOut : out STD_LOGIC_VECTOR (255 downto 0));
    end component;

    signal counter : std_logic_vector(31 downto 0) := x"00000000";
    signal dataIn : std_logic_vector(511 downto 0);
    signal pipeOut : std_logic_vector(255 downto 0);
    signal ledT : std_logic_vector(7 downto 0) := "00000000";

    --testing...
--    signal clock : std_logic := '0';
    
begin
    --testing...
--    process begin
--          wait for 5 ns;
--          clock <= not clock;
--    end process;


    process(clock)
    begin
        if rising_edge(clock) then
            counter <= counter + '1';    
        end if;
    end process;

    dataIn <= counter & x"000000000000000000000000a0000b000c00000d0000e0000000f00000000000000000000000000000000000000000000000000000000000" & counter;

    sha256_full_inst : sha256_full_top Port Map (clock, x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19", dataIn, pipeOut);
    
    led_gen : for i in 0 to 7 generate
        process(clock)
        begin
            if rising_edge(clock) then
                if pipeOut(32*(i+1)-1 downto 32*i) < x"000000" & sw & x"f" then
                    ledT(i) <= not ledT(i);
                end if;
            end if;
        end process;
    end generate;
    
    led <= ledT;

end Behavioral;
