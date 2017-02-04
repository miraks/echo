defmodule Reporter.Report do
  @enforce_keys [:title, :columns, :rows]
  defstruct [:title, :columns, :rows]
end
