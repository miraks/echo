defmodule MoexHelper.User do
  use MoexHelper.Web, :model

  alias MoexHelper.UserAction.EncryptPassword

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :accounts, MoexHelper.Account
    has_many :ownerships, through: [:accounts, :ownerships]
    has_many :coupons, through: [:ownerships, :coupons]
    has_many :redemptions, through: [:ownerships, :redemptions]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :encrypted_password, :password])
    |> encrypt_password
    |> validate_required([:email, :encrypted_password])
    |> unique_constraint(:email)
  end

  defp encrypt_password(changeset) do
    case fetch_change(changeset, :password) do
      {:ok, password} ->
        changeset
        |> delete_change(:password)
        |> put_change(:encrypted_password, EncryptPassword.call(password))
      :error -> changeset
    end
  end
end
