defmodule JSON do
  alias JSONStringifier

  @spec stringify(any()) :: binary()
  def stringify(val) do
    JSONStringifier.stringify(val)
  end

  @spec stringify() :: nil
  def stringify() do
    nil
  end
end
