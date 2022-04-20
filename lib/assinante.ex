defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastro de tipos de assinantes como prepago e pospago
  """
  defstruct nome: nil, cpf: nil, numero: nil, plano: nil
  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  @doc """
  Função para cadastrar usuarios, tanto do plano prepago quanto do pospago

  ## Params

  - nome: nome do usuario(string)
  - numero: numero do usuario(string)
  - cpf: cpf do usuario(string)
  - plano: plano do usuario(`:prepago` ou `:pospago`), caso parametro n seja informado, o valor default é `:prepago`

  informações adicionais:
  - caso o usuario ja esteja cadastrado o retorno será `{:error, "numero já cadastrado"}`

  ## Exemplo

      iex> Assinante.cadastrar("joao", "9999999", "00000000")
      {:ok, "assinante joao cadastrado com sucesso"}
  """
  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "assinante #{nome} cadastrado com sucesso"}

      _assinante ->
        {:error, "numero já cadastrado"}
    end
  end

  @doc """
  Função para buscar assinantes por `numero` e `key`.

  `key` possui o valor default de `:all` o que significa que a busca será feita na concatenacao de listas de prepagos ++ pospagos

  caso o valor exista na base de dados, irá retornar uma estrutura de `Assinante` caso contrario `nil`

  ## Exemplo

      iex> Assinante.cadastrar("joao", "9999999", "00000000")
      iex> Assinante.buscar_assinante("9999999")
      %Assinante{cpf: "00000000", nome: "joao", numero: "9999999", plano: :prepago}
  """
  def buscar_assinante(numero, key \\ :all) do
    buscar(numero, key)
  end

  defp buscar(numero, :prepago) do
    filtro(assinantes_prepago(), numero)
  end

  defp buscar(numero, :pospago) do
    filtro(assinantes_pospago(), numero)
  end

  defp buscar(numero, :all) do
    filtro(assinantes(), numero)
  end

  defp filtro(lista, numero), do: lista |> Enum.find(&(&1.numero == numero))

  defp assinantes, do: read(:prepago) ++ read(:pospago)
  defp assinantes_prepago, do: read(:prepago)
  defp assinantes_pospago, do: read(:pospago)

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, _} ->
        {:error, "problemas no arquivo de leitura"}
    end
  end
end
