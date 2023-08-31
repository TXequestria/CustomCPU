library ieee;
use ieee.std_logic_1164.all;

entity ir is
	port(mem_data:  in std_logic_vector(15 downto 0);
	     rec:       in std_logic_vector(1 downto 0);
	     clk,reset: in std_logic;
	     q:         out std_logic_vector(15 downto 0));
end ir;

architecture behave of ir is
begin
	process(clk,reset)
	begin
		if reset = '0' then            
          q <= "0000000000000000";
        elsif clk'event and clk = '1' then
			case rec is --rec = 10时，ir读取内存
				when "10"=>
				q <= mem_data;
				when others=>
				null;
			end case;		
        end if;
	end process;
end behave;