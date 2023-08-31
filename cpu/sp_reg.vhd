library ieee;
use ieee.std_logic_1164.all;
--程序寄存器，存储指令在内存中的地址
entity sp_reg is
	port(alu_out:   in std_logic_vector(15 downto 0);
	     sp_en:        in std_logic;
	     clk,reset: in std_logic;
	     q:         out std_logic_vector(15 downto 0));
end sp_reg;

architecture behave of sp_reg is
begin
	process(clk,reset)
	begin
		if reset = '0' then            
			q <= "0000000000000000";
        elsif clk'event and clk = '1' then
			if sp_en = '1' then
				q <= alu_out;
			end if;
        end if;
	end process;
end behave;