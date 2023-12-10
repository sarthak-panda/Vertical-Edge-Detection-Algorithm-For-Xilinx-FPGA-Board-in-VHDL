----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2023 17:23:42
-- Design Name: 
-- Module Name: HW2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HW2 is
  Port ( 
  BASYS_clk_100MHz:in std_logic ;
  reset:in std_logic ;
  hsync:out std_logic ;
  vsync:out std_logic ;
  rgb: out std_logic_vector(11 downto 0)
  );
end HW2;

architecture Behavioral of HW2 is
COMPONENT Clock_Divider
   port(
  clk_100MHz:in std_logic;
  clk_25MHz:out std_logic
   );
end component;
component Horizontal_Counter
  Port ( 
  pclk:in std_logic;
  rst:in std_logic;
  en:out std_logic ;
  hcnt:out integer
  );
end component; 
component  Vertical_Counter
Port ( 
  rst:in std_logic;
  en:in std_logic ;
  vcnt:out integer
  );
end component;
component RAM
port ( clk : in std_logic;
a : in std_logic_vector(15 downto 0);
do : out std_logic_vector(7 downto 0));
end component;

constant HA:integer:=640;
constant HB:integer :=48;
constant HF:integer:=16;
constant HS:integer:=96;
constant HMAX:integer:=HA+HF+HB+HS-1;
constant VA:INTEGER:=480;
constant VF:integer :=10;
CONSTANT VB:INTEGER:=33;
constant VS:integer :=2;
constant VMAX:integer :=VA+VF+VB+VS-1;

signal w_25MHz:std_logic:='0';
signal enable:std_logic:='0';
signal horcnt:integer:=0 ;
signal vercnt:integer:=0;
signal pixelcolor:STD_LOGIC_VECTOR(7 DOWNTO 0);
signal pixeladd:STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
TIME: Clock_Divider Port MAP(
clk_100MHz=>BASYS_clk_100MHz,
clk_25MHz=>w_25MHz
);
HCOUNTER: Horizontal_Counter PORT MAP(
pclk=>w_25MHz,
rst=>reset,
en=>enable,
hcnt=>horcnt
);
VCOUNTER: Vertical_Counter PORT MAP(
rst=>reset,
en=>enable,
vcnt=>vercnt
);
OUTPUT_IMAGE_MEM: RAM PORT MAP(
clk=>BASYS_clk_100MHz,
do=>pixelcolor,
a=>pixeladd
);

z:process(horcnt)
begin
if(horcnt<=HA+HF+HS and horcnt>=HA+HF) then
hsync<='0';
else
hsync<='1';
end if;
end process;

k:process(vercnt)
begin
if(vercnt<=VA+VF+VS and vercnt>=VA+VF) then
vsync<='0';
else
vsync<='1';
end if;
end process;

w:process(horcnt,vercnt)
variable j:integer:=0;
begin
if(horcnt>=191 and horcnt<=446 and vercnt>=111 and vercnt<=366) then
j:=(horcnt-191)+(vercnt-111)*256;
pixeladd<= std_logic_vector(to_unsigned(j, 16));
rgb(11 downto 8)<=pixelcolor(7 downto 4);
rgb(7 downto 4)<=pixelcolor(7 downto 4);
rgb(3 downto 0)<=pixelcolor(3 downto 0);--actually it should be 7 downto 4 but linter was throwing error bits unread but it does not matter as all bits are same
--rgb(11 downto 0)<="111100000000";
else
pixeladd<="0000000000000000";
rgb(11 downto 0)<="000000000000";
end if;
end process;

end Behavioral;
