library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
entity RAM is
port ( clk : in std_logic;
a : in std_logic_vector(15 downto 0);
do : out std_logic_vector(7 downto 0));
end RAM;
architecture syn of RAM is
COMPONENT dist_mem_gen_0
PORT(
a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
clk: IN std_logic 
);
end component;
type ram_type is array (65535 downto 0) of std_logic_vector (7 downto 0);
signal RAM : ram_type;
signal p0:signed(9 downto 0):="0011111111";
signal p1:signed(9 downto 0):="0011111111";
signal p2:signed(9 downto 0):="0011111111";
signal wr_comp:integer:=0;
signal romadd:std_logic_vector(15 downto 0) := (others => '0');
signal romd:std_logic_vector(7 downto 0) := (others => '0');
signal di:std_logic_vector(7 downto 0) := (others => '0');
signal io:integer:=0;
begin
ROM:dist_mem_gen_0 PORT MAP (
clk=> clk,
spo=> romd,
a=> romadd
);
process(clk) 
variable i:integer:=0;
variable gx:signed(9 downto 0):= (others => '0');
variable g:unsigned (7 downto 0):= (others => '0');
variable h:unsigned(9 downto 0):= (others => '0');
begin
if(rising_edge(clk)) then
if(i<65536) then
 if (wr_comp = 0) then
 romadd <= std_logic_vector(to_unsigned(i, 16));
 --increment the address
   p2<=p1;
   p1<=p0;
   g:=unsigned(romd(7 downto 0));
   h:=RESIZE(g, 10);
   p0 <= signed(h);
   gx:=p0+p2-p1-p1;
   if(i>=1) then
   di<=RAM(i-1);
   end if;
   if gx(9)='1' then
        RAM(i)<="00000000";
        io<=i;
   elsif gx(9 downto 8)="01" then
        RAM(i)<="11111111";
        io<=i;
   else
        RAM(i)<=std_logic_vector (gx(7 downto 0));
        io<=i;
   end if;
   i := i + 1;
 wr_comp <= wr_comp + 1;
 elsif (wr_comp = 1) then
 wr_comp <= wr_comp + 1;
 elsif (wr_comp = 2) then
 wr_comp <= 0;
 end if;
else
do <= RAM(conv_integer(a));
end if;
end if;
end process;
end syn;
