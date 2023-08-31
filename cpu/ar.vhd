library ieee;
use ieee.std_logic_1164.all;
--地址寄存器
entity ar is
	port(alu_out:   in std_logic_vector(15 downto 0);
	     pc:        in std_logic_vector(15 downto 0);
	     rec:       in std_logic_vector(1 downto 0);
	     clk,reset: in std_logic;
	     q:         out std_logic_vector(15 downto 0));
end ar;

architecture behave of ar is
begin
	process(clk,reset)
	begin
		if reset = '0' then            
          q <= "0000000000000000";
        elsif clk'event and clk = '1' then
			case rec is --rec = 01 的时候，AR接受PC地址
				when "01"=> 
				q <= pc;
				when "11"=>
				q <= alu_out; --rec = 11时，AR接受PC输出
				when others=>
				null;
			end case;		
        end if;
	end process;
end behave;