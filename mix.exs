defmodule Bitmap.Mixfile do
  use Mix.Project

  def project do
    [app: :bitmap,
     version: "1.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     source_url: "https://github.com/hashd/bitmap-elixir",
     homepage_url: "https://github.com/hashd/bitmap-elixir",
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.15", only: :dev},
      {:benchfella, "~> 0.3.0", only: :dev}
    ]
  end

  defp description do
    """
    Package to help you create and work with bitmaps (https://en.wikipedia.org/wiki/Bitmap)
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Kiran Danduprolu", "parroty", "freandre"]
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/hashd/bitmap-elixir"
      }
    ]
  end
end
