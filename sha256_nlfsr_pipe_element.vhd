--(c) Fekete Balázs Valér fbv81bp@outlook.hu fbv81bp@gmail.com All rights reserved!

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sha256_nlfsr_pipe_element is
    Port ( clock : in STD_LOGIC;
           wIn   : in  STD_LOGIC_VECTOR(511 downto 0);-- := x"61626308032478654874656987985696585698654825548f9548954e8945652a65458958b548548c46558958e95495a9545d458585580a65b95954e95d65c9d8";
           wOut  : out STD_LOGIC_VECTOR(511 downto 0));
end sha256_nlfsr_pipe_element;

architecture Behavioral of sha256_nlfsr_pipe_element is

    component distRAM5x32w2cnt is
        Port ( clock : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (31 downto 0);
               reg0 : out STD_LOGIC_VECTOR (31 downto 0);
               reg1 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    component LUT5x32w2out is
        Port ( clock : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (31 downto 0);
               reg0 : out STD_LOGIC_VECTOR (31 downto 0);
               reg1 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;

    signal s0, s1 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal r0, r1, r2, r3, r4, r5, r6, r7, s0in, s1in, sumI: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    type wT is array (15 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal wi, wo : wT;

    --testing...
--    signal clock : std_logic := '0';
--    signal wIn : std_logic_vector(511 downto 0);
    
begin
    --testing...
--    process begin
--        wait for 5 ns;
--        clock <= not clock;
--    end process;

--    process begin
--        wait for 50 ns;
--        wIn <= x"11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
--        wait for 10 ns;
--        wIn <= x"22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222";
--        wait for 10 ns;
--        wIn <= x"33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333";
--        wait for 10 ns;
--        wIn <= x"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
--        wait for 10 ns;
--        wIn <= x"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
--        wait for 10 ns;
--        wIn <= x"cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc";
--        wait;
--    end process;

    

    wi(0) <= wIn(31 downto 0);
    wi(1) <= wIn(63 downto 32);
    wi(2) <= wIn(95 downto 64);
    wi(3) <= wIn(127 downto 96);
    wi(4) <= wIn(159 downto 128);
    wi(5) <= wIn(191 downto 160);
    wi(6) <= wIn(223 downto 192);
    wi(7) <= wIn(255 downto 224);
    wi(8) <= wIn(287 downto 256);
    wi(9) <= wIn(319 downto 288);
    wi(10) <= wIn(351 downto 320);
    wi(11) <= wIn(383 downto 352);
    wi(12) <= wIn(415 downto 384);
    wi(13) <= wIn(447 downto 416);
    wi(14) <= wIn(479 downto 448);
    wi(15) <= wIn(511 downto 480);

    shiftReg1  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 0), reg0 => open, reg1 => wo( 1));
    shiftReg2  : LUT5x32w2out     Port Map (clock => clock, data => wi( 1), reg0 => s1in, reg1 => wo( 2));
    shiftReg3  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 2), reg0 => open, reg1 => wo( 3));
    shiftReg4  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 3), reg0 => open, reg1 => wo( 4));
    shiftReg5  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 4), reg0 => open, reg1 => wo( 5));
    shiftReg6  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 5), reg0 => open, reg1 => wo( 6));
    shiftReg7  : LUT5x32w2out     Port Map (clock => clock, data => wi( 6), reg0 => r4,   reg1 => wo( 7));
    shiftReg8  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 7), reg0 => open, reg1 => wo( 8));
    shiftReg9  : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 8), reg0 => open, reg1 => wo( 9));
    shiftReg10 : distRAM5x32w2cnt Port Map (clock => clock, data => wi( 9), reg0 => open, reg1 => wo(10));
    shiftReg11 : distRAM5x32w2cnt Port Map (clock => clock, data => wi(10), reg0 => open, reg1 => wo(11));
    shiftReg12 : distRAM5x32w2cnt Port Map (clock => clock, data => wi(11), reg0 => open, reg1 => wo(12));
    shiftReg13 : distRAM5x32w2cnt Port Map (clock => clock, data => wi(12), reg0 => open, reg1 => wo(13));
    shiftReg14 : distRAM5x32w2cnt Port Map (clock => clock, data => wi(13), reg0 => open, reg1 => wo(14));
    shiftReg15 : distRAM5x32w2cnt Port Map (clock => clock, data => wi(14), reg0 => s0in, reg1 => wo(15));
     
    s0 <= (s0in(6 downto 0) & s0in(31 downto 7)) xor (s0in(17 downto 0) & s0in(31 downto 18)) xor ("000" & s0in(31 downto 3));
    s1 <= (s1in(16 downto 0) & s1in(31 downto 17)) xor (s1in(18 downto 0) & s1in(31 downto 19)) xor ("0000000000" & s1in(31 downto 10));
    
    nlfsr: process(clock)
        begin
            if rising_edge(clock) then
                r0 <= wi(15);
                r1 <= r0;
                r2 <= s0;
                r3 <= r1 + r2;
                r5 <= r3 + r4;
                r6 <= s1;
                r7 <= r6 + r5;
            end if;
        end process;
    
    wOut <= wo(15) & wo(14) & wo(13) & wo(12) & wo(11) & wo(10) & wo(9) & wo(8) & wo(7) & wo(6) & wo(5) & wo(4) & wo(3) & wo(2) & wo(1) & r7;
    
end Behavioral;
