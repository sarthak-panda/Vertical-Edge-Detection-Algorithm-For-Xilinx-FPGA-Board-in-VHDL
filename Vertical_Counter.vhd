LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Vertical_Counter IS
	PORT
	(
		rst : IN std_logic;
		en : IN std_logic;
		vcnt : OUT INTEGER
	);
END Vertical_Counter;
ARCHITECTURE Behavioral OF Vertical_Counter IS
	CONSTANT VA : INTEGER := 480;
	CONSTANT VF : INTEGER := 10;
	CONSTANT VB : INTEGER := 33;
	CONSTANT VS : INTEGER := 2;
	CONSTANT VMAX : INTEGER := VA + VF + VB + VS - 1;
	SIGNAL vcount : INTEGER := 0;
BEGIN
	t : PROCESS (en, rst)
	BEGIN
		IF rst = '1' THEN
			vcnt <= 0;
			vcount <= 0;
		ELSIF en'EVENT AND en = '1' THEN
			IF vcount = VMAX THEN
				vcount <= 0;
				vcnt <= vcount;
			ELSE
				vcount <= vcount + 1;
				vcnt <= vcount;
			END IF;
		END IF;
	END PROCESS;
END Behavioral;