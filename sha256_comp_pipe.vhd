--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_comp_pipe is
    Generic(stages : integer := 64);
    Port ( clock : in STD_LOGIC;
           pipeIn : in STD_LOGIC_VECTOR (255 downto 0);
           kwSumIn : in STD_LOGIC_VECTOR (32 * stages - 1 downto 0);
           pipeOut : out STD_LOGIC_VECTOR (255 downto 0));
end sha256_comp_pipe;

architecture Behavioral of sha256_comp_pipe is

    component sha256_comp_pipe_element is
        Port ( clock : in STD_LOGIC;
               pipeIn : in STD_LOGIC_VECTOR (255 downto 0);
               kwSumIn : in STD_LOGIC_VECTOR (31 downto 0);
               pipeOut : out STD_LOGIC_VECTOR (255 downto 0));
    end component;

    type pT is array (0 to stages) of STD_LOGIC_VECTOR(255 downto 0);
    signal pipe : pT;

begin

    pipe(0) <= pipeIn;

    comp_gen : for i in 0 to stages - 1 generate
        comp_inst : sha256_comp_pipe_element Port Map(clock, pipe(i), kwSumIn(32*(i+1)-1 downto 32*i), pipe(i+1));
    end generate;

    pipeOut <= pipe(stages);

end Behavioral;
