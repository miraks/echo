defmodule MoexHelper.UserAction.EncryptPassword do
  def call(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
