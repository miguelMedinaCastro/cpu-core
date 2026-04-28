library ieee;
use ieee.std_logic_1164.all;

entity fsm is
  port (
    clk     : in std_logic;
    reset   : in std_logic;
    entrada : in std_logic;
    saida   : out std_logic
  );
end entity;

architecture behavior of fsm is

  type estado_t is (dormindo, acorda, levanta, cafe_manha, escova_dentes, sair);
  signal estado_atual, prox_estado : estado_t;

begin

  process (clk, reset)
  begin
    if reset = '1' then
      estado_atual <= dormindo;
    elsif rising_edge(clk) then
      estado_atual <= prox_estado;
    end if;
  end process;

  process (estado_atual, entrada)
  begin
    case estado_atual is
      when dormindo =>
        if entrada = '1' then
          prox_estado <= acorda;
        else
          prox_estado <= dormindo;
        end if;

      when acorda =>
        if entrada = '1' then
          prox_estado <= levanta;
        else
          prox_estado <= acorda;
        end if;

      when levanta =>
        if entrada = '1' then
          prox_estado <= cafe_manha;
        else
          prox_estado <= levanta;
        end if;

      when cafe_manha =>
        if entrada = '1' then
          prox_estado <= escova_dentes;
        else
          prox_estado <= cafe_manha;
        end if;

      when escova_dentes =>
        if entrada = '1' then
          prox_estado <= sair;
        else
          prox_estado <= escova_dentes;
        end if;

      when sair =>
        if entrada = '1' then
          prox_estado <= dormindo;
        else
          prox_estado <= sair;
        end if;

      when others =>
        prox_estado <= dormindo;
    end case;
  end process;

  saida <= '1' when estado_atual = sair else
    '0';

end architecture;