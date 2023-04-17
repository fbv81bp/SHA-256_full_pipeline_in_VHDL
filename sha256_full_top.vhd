--Copyright (C) Balazs Valer FEKETE, fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_full_top is
    Port ( clock : in STD_LOGIC;
           pipeInit : in STD_LOGIC_VECTOR (255 downto 0);-- := x"6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19";
           dataIn : in STD_LOGIC_VECTOR (511 downto 0);-- := x"61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018";
           pipeOut : out STD_LOGIC_VECTOR (255 downto 0));-- x"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
                                                          --   ba7816c08f01cfea414140df5dae2223b00361a496177a9cb410ff61f20015ad okay
end sha256_full_top;

architecture Behavioral of sha256_full_top is

    component sha256_nlfsr_pipe is
            Port ( clock : in STD_LOGIC;
                   wIn   : in  STD_LOGIC_VECTOR(511 downto 0);
                   wOut  : out STD_LOGIC_VECTOR(2047 downto 0)); --stage 0 data is at 32 MSBs
    end component;
    
    component sha256_comp_pipe is
        Generic(stages : integer := 64);
        Port ( clock : in STD_LOGIC;
               pipeIn : in STD_LOGIC_VECTOR (255 downto 0);
               kwSumIn : in STD_LOGIC_VECTOR (32 * stages - 1 downto 0);
               pipeOut : out STD_LOGIC_VECTOR (255 downto 0));
    end component;

	type initT is array (7 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	constant init : initT := (
		x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19");
	type kT is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
	constant k : kT := (
		x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
		x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
		x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
		x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
		x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
		x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
		x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
		x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2");

    signal result  : STD_LOGIC_VECTOR(255 downto 0);
    signal  wOut, kwSumIn, kwSumReg1, kwSum, kwSumReg2  : STD_LOGIC_VECTOR(2047 downto 0);

    --testing...
--    signal clock : std_logic := '0';
    signal wTest : kT;
   
begin
    --testing...
    test_gen : for i in 0 to 63 generate
        wTest(i) <= kwSumIn(32*(i+1)-1 downto 32*i);
    end generate;
--    process begin
--          wait for 5 ns;
--          clock <= not clock;
--    end process;

    sha256_nlfsr_pipe_ins : sha256_nlfsr_pipe Port Map (clock, dataIn, wOut); --stage 0 data is at 32 MSBs
    
    kwSum_gen : for i in 0 to 63 generate
        kwSumIn(32*(i+1)-1 downto 32*i) <= wOut(32*(64-i)-1 downto 32*(63-i));
        kwSum(32*(i+1)-1 downto 32*i)  <= k(i) + kwSumReg1(32*(i+1)-1 downto 32*i);
    end generate;

    nlfsr: process(clock)
        begin
            if rising_edge(clock) then
                kwSumReg1 <= kwSumIn;
                kwSumReg2 <= kwSum;
            end if;
        end process;


    sha256_comp_pipe_inst : sha256_comp_pipe Generic Map (64) Port Map (clock, pipeInit, kwSumReg2, result);

    outputSum_gen : for i in 0 to 7 generate
        pipeOut(32*(i+1)-1 downto 32*i) <= result(32*(i+1)-1 downto 32*i) + init(i);
    end generate;

end Behavioral;
