library ieee;
use ieee.std_logic_1164.all;

entity fsm_tb is
end entity;

architecture sim of fsm_tb is

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal entrada : std_logic := '0';
    signal saida   : std_logic;

begin

    uut: entity work.fsm
        port map (
            clk     => clk,
            reset   => reset,
            entrada => entrada,
            saida   => saida
        );

    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        wait for 10 ns;

        entrada <= '1'; wait for 10 ns; 
        entrada <= '0'; wait for 10 ns;

        entrada <= '1'; wait for 10 ns;
        entrada <= '0'; wait for 10 ns;

        entrada <= '1'; wait for 10 ns;
        entrada <= '0'; wait for 10 ns;

        entrada <= '1'; wait for 10 ns;
        entrada <= '0'; wait for 10 ns;

        entrada <= '1'; wait for 10 ns;
        entrada <= '0'; wait for 10 ns;
        
        wait for 10 ns;
        
        assert false report "simulação feita" severity failure;
        wait;
    end process;

end architecture;