library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
    generic (
        N : natural := 4
    );
    port(
        A, B : in std_logic_vector;
        S    : out std_logic_vector(N - 1 downto 0)
    );
end decoder2x4;

architecture behavior of decoder2x4 is
    begin
        -- process(A, B)
        -- begin
        --     case A & B  is
        --         when "00" => S <= "0001";
        --         when "01" => S <= "0010";
        --         when "10" => S <= "0100";
        --         when "11" => S <= "1000";
        --         when others => S <= "0000";
        --     end case ;
        -- end process;

        S(0) <= not A and not B;
        S(1) <= not A and B;
        S(2) <= A and not B;
        S(3) <= A and B;

end behavior ;