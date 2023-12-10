LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Clock_Divider IS
	PORT
	(
		clk_100MHz : IN std_logic;
		clk_25MHz : OUT std_logic
	);
END Clock_Divider;
ARCHITECTURE Behavioral OF Clock_Divider IS
	SIGNAL r_25MHz : std_logic_vector(1 DOWNTO 0) := "00";
BEGIN
	q : PROCESS (clk_100MHz)
	BEGIN
		IF rising_edge(clk_100MHz) THEN
			IF r_25MHz = "11" THEN
				r_25MHz <= "00";
			ELSE
				r_25MHz <= std_logic_vector (unsigned(r_25MHz) + 1);
			END IF;
		END IF;
	END PROCESS;
	o : PROCESS (r_25MHz)
	BEGIN
		IF r_25MHz = "00" OR r_25MHz = "01" THEN
			clk_25MHz <= '0';
		ELSE
			clk_25MHz <= '1';
		END IF;
	END PROCESS;
END Behavioral;
