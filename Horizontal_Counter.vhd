LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Horizontal_Counter IS
	PORT
	(
		pclk : IN std_logic;
		rst : IN std_logic;
		en : OUT std_logic;
		hcnt : OUT INTEGER
	);
END Horizontal_Counter;
ARCHITECTURE Behavioral OF Horizontal_Counter IS
	CONSTANT HA : INTEGER := 640;
	CONSTANT HB : INTEGER := 48;
	CONSTANT HF : INTEGER := 16;
	CONSTANT HS : INTEGER := 96;
	CONSTANT HMAX : INTEGER := HA + HF + HB + HS - 1;
	SIGNAL hcount : INTEGER := 0;
BEGIN
	m : PROCESS (pclk, rst)
	BEGIN
		IF (rst = '1') THEN
			hcnt <= 0;
			hcount <= 0;
			en <= '0';
		ELSIF rising_edge (pclk) THEN
			IF hcount = HMAX THEN
				hcount <= 0;
				hcnt <= hcount;
				en <= '1';
			ELSE
				hcount <= hcount + 1;
				hcnt <= hcount;
				en <= '0';
			END IF;
		END IF;
	END PROCESS;
END Behavioral;