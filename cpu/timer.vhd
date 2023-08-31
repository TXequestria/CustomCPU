library ieee;
use ieee.std_logic_1164.all;
--时钟信号与状态控制器
entity timer is
   port(
      clk      : in std_logic;
      reset    : in std_logic;
      ins      : in std_logic_vector(15 downto 0);
      output   : out std_logic_vector(2 downto 0);
		counter_timer : out std_logic);
end timer;

architecture behave of timer is
	type state_type is(s0,s1,s2,s3,s4,s5);
	signal state:state_type;
begin
	process(clk,reset,ins)
	variable true_ins : std_logic_vector(15 downto 0);
	variable counter : std_logic;
	begin
		if reset='0' then state<=s0;
		elsif (clk'event and clk='1') then
			case state is
				when s0=>
					true_ins := "0000000000000000";
					counter := '0';
					state<=s1;
				when s1=>
					true_ins := "0000000000000000";
					counter := '0';
					state<=s2;
				when s2=>
					if ins(15)='0' then
					state<=s3;
					else state<=s4;
					end if;
					true_ins := ins;
				when s3=>
					state<=s1;
				when s4=>
					state<=s5;
				when s5=>
					if true_ins(14)='1' and counter = '0' then
					counter := '1';
					state<=s4;
					else
					state<=s1;
					end if;
			end case;
			counter_timer <= counter;
        end if;
	end process;
	process(state)
	begin
		case state is
			when s0=>
			output<="100"; --PC地址给AR，PC自加1
			when s1=>
			output<="000"; --初始状态
			when s2=>
			output<="001"; --读内存
			when s3=>
			output<="011"; --寄存器间的数据传送
			when s4=>
			output<="101"; --传送地址给AR
			when s5=>
			output<="111";--读写内存
			end case;
	end process;
end behave;	