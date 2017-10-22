defmodule MoexHelper.I18n do
  @translations %{
    en: %{
      security: %{
        data: %{
          secname: "Name",
          prevprice: "Last deal price",
          couponvalue: "Coupon value",
          nextcoupon: "Next coupon",
          matdate: "Maturity",
          lotsize: "Lot size"
        }
      }
    }
  }

  def t(path) when is_binary(path) do
    path |> String.split(".") |> Enum.map(&String.to_atom/1) |> t
  end

  def t(path) do
    get_in(@translations, path)
  end

  def translations do
    @translations
  end
end
