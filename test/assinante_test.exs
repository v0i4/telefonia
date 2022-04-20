defmodule AssinanteTest do
  use ExUnit.Case
  doctest(Assinante)

  setup  do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "testes relacionados aos arquivos de leitura/escrita" do
    refute Assinante.read(:pospago) != {:error, "problemas no arquivo de leitura"}
    refute Assinante.read(:prepago) != {:error, "problemas no arquivo de leitura"}


  end

  describe "testes relacionados a cadastro de assinantes" do

    test "deve retornar estrutura de assinante" do
      assert %Assinante{nome: "teste", numero: "999999", cpf: "0000000", plano: "plano"}.nome == "teste"
    end

    test "criar conta do plano pre pago" do
      assert Assinante.cadastrar("antonio", "99999999", "00000000", :prepago) ==
        {:ok, "assinante antonio cadastrado com sucesso"}
    end

    test "deve retornar erro caso o usuario ja esteja cadastrado" do
      Assinante.cadastrar("antonio", "99999999", "00000000", :prepago)

      assert Assinante.cadastrar("antonio", "99999999", "00000000", :prepago) ==
        {:error, "numero já cadastrado"}
    end
  end

  describe "testes responsaveis por busca de assinantes" do

    test "busca pospago" do
      Assinante.cadastrar("antonio", "99999999", "00000000", :pospago)

      assert Assinante.buscar_assinante("99999999", :pospago).nome == "antonio"

    end

    test "busca prepago" do
      Assinante.cadastrar("antonio", "99999999", "00000000")

      assert Assinante.buscar_assinante("99999999", :prepago).nome == "antonio"

    end
  end

end
