defmodule EmqxCleanspeakPlugin.Mixfile do
  use Mix.Project

  def project do
    [
      app: :emq_cleanspeak_plugin,
      version: "2.3.2",
      elixir: "~> 1.7",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EmqxCleanspeakPlugin, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cuttlefish, github: "emqx/cuttlefish", tag: "exs-3.0.0", manager: :rebar3, override: true},
      {:emqx, github: "emqx/emqx", branch: branch()},
      {:ssl_verify_fun, "1.1.6", override: true},
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.2"}
    ]
  end

  defp branch do
     cur_branch = :os.cmd('git branch | grep -e \'^*\' | cut -d\' \' -f 2') -- '\n'
     to_string(case :lists.member(cur_branch, ['master', 'develop']) do
                  true -> cur_branch
                  false -> 'develop'
              end)
  end
end
