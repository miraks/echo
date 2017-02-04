defmodule MoexHelper.Web do
  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias MoexHelper.Repo
      import Ecto
      import Ecto.Query
      import Guardian.Plug, only: [current_resource: 1]

      import MoexHelper.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import MoexHelper.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias MoexHelper.Repo
      import Ecto
      import Ecto.Query
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
