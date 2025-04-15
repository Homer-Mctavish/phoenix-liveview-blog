defmodule DogBlog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DogBlogWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:dog_blog, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DogBlog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DogBlog.Finch},
      # Start a worker by calling: DogBlog.Worker.start_link(arg)
      # {DogBlog.Worker, arg},
      # Start to serve requests, typically the last entry
      DogBlogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DogBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DogBlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
