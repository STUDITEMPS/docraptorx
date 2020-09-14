defmodule Docraptorx.Mixfile do
  use Mix.Project

  def project do
    [app: :docraptorx,
     version: "0.1.1",
     elixir: "~> 1.2",
     description: "Docraptor API client",
     package: [
       maintainers: ["Kaname"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/asacraft/docraptorx"}
     ],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison, :exjsx]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 1.6"},
     {:exjsx, "~> 3.2"},
     {:exml, "~> 0.1.0"},
     {:earmark, "~> 1.0", only: :dev},
     {:ex_doc, "~> 0.13.1", only: :dev}]
  end
end
