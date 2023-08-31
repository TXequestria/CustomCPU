library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity alu is
port(cin:in std_logic;--杩涗綅杈撳叆
     alu_a,alu_b:in std_logic_vector(15 downto 0);
     alu_func:in std_logic_vector(3 downto 0);
     alu_out:out std_logic_vector(15 downto 0);
     c,z,v,s:out std_logic);--c:杩涗綅鏍囧織 z锛氫负闆舵爣蹇s绗﹀彿浣v锛氭孩鍑烘爣蹇
end alu;

architecture behave of alu is
begin
	process(alu_a,alu_b,cin,alu_func)
	variable temp1,temp2,temp3 : std_logic_vector(15 downto 0) ;
	variable rotate_times:std_logic_vector(3 downto 0);
	variable high_bit:std_logic;
	begin
		for I in 3 downto 0 loop
		rotate_times(I):= alu_a(I);
		end loop;
		temp1 := "000000000000000"&cin;
		case alu_func is
			when "0000"=>--甯﹁繘浣嶅姞娉
			temp2 := alu_b+alu_a+temp1;
			when "0001"=>--甯﹀€熶綅鍑忔硶
			temp2 := alu_b-alu_a-temp1;
			when "0010"=>--涓庤繍绠
			temp2 := alu_a and alu_b;
			when "0011"=>--鎴栬繍绠
			temp2 := alu_a or alu_b;
			when "0100"=>--寮傛垨杩愮畻
			temp2 := alu_a xor alu_b;
			when "0101"=>--宸︾Щ
			temp2(0) := '0';
			for I in 15 downto 1 loop
			temp2(I) := alu_b(I-1);
			end loop;
			when "0110"=>--鍙崇Щ
			temp2(15) := '0';
			for I in 14 downto 0 loop
			temp2(I) := alu_b(I+1);
			end loop;
			when "0111"=>--寰幆宸︾Щ锛屽亣璁綼lu_b 鏄洰鏍囧瘎瀛樺櫒 alu_a 鏄Щ浣嶆鏁
			temp2 := alu_b;
			for J in 15 downto 0 loop
			exit when (rotate_times<"0001");
			rotate_times:=rotate_times-"0001";
			high_bit := temp2(15);
			for I in 15 downto 1 loop
			temp2(I):=temp2(I-1);
			end loop;
			temp2(0):=high_bit;
			end loop;
			when others=>
		end case;
		alu_out <= temp2;
		if temp2 = "0000000000000000" then z<='1';
		else z<='0';
		end if;
		if temp2(15) = '1' then s<='1';
		else s<='0';
		end if;
		case alu_func is
			when "0000" | "0001"=>
			if (alu_a(15)= '1' and alu_b(15)= '1' and temp2(15) = '0') or
			   (alu_a(15)= '0' and alu_b(15)= '0' and temp2(15) = '1') then
			v<='1';
			else v<='0';
			end if;
			when others=>
			v<='0';
		end case;
		case alu_func is
			when "0000"=>
			temp3 := "1111111111111111"-alu_b-temp1;
			if temp3<alu_a then
			c<='1';
			else c<='0';
			end if;
			when "0001"=>
			if alu_b<alu_a then
			c<='1';
			else c<='0';
			end if;
			when "0101"=>
			c <= alu_b(15);
			when "0110"=>
			c <= alu_b(0);
			when "0111"=>
			c<=high_bit;
			when others=>
			c<='0';
		end case;
	end process;
end behave;