----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/08/2026 12:17:34 AM
-- Design Name: 
-- Module Name: decoder_tb - Behavior
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder_tb is
end decoder_tb;

architecture Behavior of decoder_tb is
    constant N : natural := 4;

    signal A, B : std_logic := '0';
    signal S    : std_logic_vector(N-1 downto 0); 
begin

    uut: entity work.decoder2x4
        generic map (
            N => N
        
        )
        port map (
            A => A,
            B => B,
            S => S
        );
        
    process
    begin
        -- 00
        A <= '0'; B <= '0';
        wait for 10 ns;

        -- 01
        A <= '0'; B <= '1';
        wait for 10 ns;

        -- 10
        A <= '1'; B <= '0';
        wait for 10 ns;

        -- 11
        A <= '1'; B <= '1';
        wait for 10 ns;
        
        wait;
    
    end process;
end Behavior;
