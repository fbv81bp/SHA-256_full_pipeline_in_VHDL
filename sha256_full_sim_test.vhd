--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

--Results:
    --ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad expected
    --ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad okay
    
    --a6b0f90d2ac2b8d1f250c687301aef132049e9016df936680e81fa7bc7d81d70 expected
    --a6b0f90d2ac2b8d1f250c687301aef132049e9016df936680e81fa7bc7d81d70 okay
    
    --08a018a9549220d707e11c5c4fe94d8dd60825f010e71efaa91e5e784f364d7b expected
    --08a018a9549220d707e11c5c4fe94d8dd60825f010e71efaa91e5e784f364d7b okay
    
    --cb8379ac2098aa165029e3938a51da0bcecfc008fd6795f401178647f96c5b34 expected
    --cb8379ac2098aa165029e3938a51da0bcecfc008fd6795f401178647f96c5b34 okay
    
    --d4ffe8e9ee0b48eba716706123a7187f32eae3bdcb0e7763e41e533267bd8a53 expected
    --d4ffe8e9ee0b48eba716706123a7187f32eae3bdcb0e7763e41e533267bd8a53 okay

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_full_sim_test is
end sha256_full_sim_test;

architecture Behavioral of sha256_full_sim_test is

    component sha256_full_top is
        Port ( clock : in STD_LOGIC;
               pipeInit : in STD_LOGIC_VECTOR (255 downto 0);
               dataIn : in STD_LOGIC_VECTOR (511 downto 0);
               pipeOut : out STD_LOGIC_VECTOR (255 downto 0));
    end component;

    signal clock : std_logic := '0';
    signal pipeInit : STD_LOGIC_VECTOR (255 downto 0);
    signal dataIn : STD_LOGIC_VECTOR (511 downto 0);
    signal pipeOut : STD_LOGIC_VECTOR (255 downto 0);
    
begin

    clock_proc : process begin
          wait for 5 ns;
          clock <= not clock;
    end process;

    stimulus : process begin
        pipeInit <= x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
        wait for 100 ns;
        dataIn <= x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
        wait for 10 ns;
        dataIn <= x"62636480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
        wait for 10 ns;
        dataIn <= x"63646580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
        wait for 10 ns;
        dataIn <= x"64656680000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
        wait for 10 ns;
        dataIn <= x"65666780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
        wait for 10 ns;
        wait;
    end process;

    sha256_full_inst : sha256_full_top Port Map (clock, pipeInit, dataIn, pipeOut);

end Behavioral;
