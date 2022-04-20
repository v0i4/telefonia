defmodule Telefonia do

  @planos %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def start do
    File.write(@planos[:prepago], :erlang.term_to_binary([]))
    File.write(@planos[:pospago], :erlang.term_to_binary([]))
  end

  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end
end
