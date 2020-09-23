--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_nlfsr_pipe is
        Port ( clock : in STD_LOGIC;
               wIn   : in  STD_LOGIC_VECTOR(511 downto 0);
               wOut  : out STD_LOGIC_VECTOR(2047 downto 0)); --stage 0 data is at 32 MSBs
end sha256_nlfsr_pipe;

architecture Behavioral of sha256_nlfsr_pipe is

    component sha256_nlfsr_pipe_element is
        Port ( clock : in STD_LOGIC;
               wIn   : in  STD_LOGIC_VECTOR(511 downto 0);
               wOut  : out STD_LOGIC_VECTOR(511 downto 0));
    end component;

    type wT is array (0 to 48) of STD_LOGIC_VECTOR(511 downto 0);
    signal w : wT;
    signal first48 : STD_LOGIC_VECTOR(1535 downto 0);
    type lastWrowT is array (0 to 75) of STD_LOGIC_VECTOR(31 downto 0);
    type lastWcolT is array (0 to 15) of lastWrowT;
    signal lastW : lastWcolT;
    signal last16 : STD_LOGIC_VECTOR(511 downto 0);

    --testing...
--    signal clock : std_logic := '0';
    
begin
    --testing...
--    process begin
--        wait for 5 ns;
--        clock <= not clock;
--    end process;


w(0) <= wIn;

nlfsr_pipe_gen : for i in 0 to 47 generate
    nlfsr_inst: sha256_nlfsr_pipe_element Port Map (clock, w(i), w(i+1));
end generate;

first48_gen : for i in 0 to 47 generate
    first48(32*(i+1)-1 downto 32*i)  <= w(47-i)(511 downto 480);
end generate;

last16_connects_gen : for i in 0 to 15 generate
    lastW(i)(0) <= w(48)(32*(i+1)-1 downto 32*i); --first row equals w(48)
    last16(32*(i+1)-1 downto 32*i) <= lastW(i)(5*(16-i)-5); --outputs at every 5th row in consecutive columns
end generate;

last16_cols_gen : for c in 0 to 15 generate
    last16_rows_gen : for r in 0 to 74 generate
        --shift_cond: if r < 5*(16-c)-5 generate
            process(clock) begin
                if rising_edge(clock) then
                    lastW(c)(r+1) <= lastW(c)(r); --shifting rows columnwise 
                end if;
            end process;
--        end generate;
    end generate;
end generate;


wOut <= first48 & last16;

end Behavioral;
