defmodule MoexHelper.UserAction.CheckPassword do
  def call(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
  end
end
