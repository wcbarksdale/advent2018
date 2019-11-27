defmodule Rotary do
  @moduledoc """
  A rotary data structure implemented on top of a zipper list, not super efficient
  """
  alias Zippy.ZList, as: Z

  @doc """
      iex(1)> Rotary.advance(Zippy.ZList.from_list([1,2,3]), 1)
      {[1], [2, 3]}
      iex(2)> Rotary.advance(Zippy.ZList.from_list([1,2,3]), 2)
      {[2, 1], [3]}
      iex(3)> Rotary.advance(Zippy.ZList.from_list([1,2,3]), 3)
      {[3, 2, 1], []}
      iex(4)> Rotary.advance(Zippy.ZList.from_list([1,2,3]), 4)
      {[1], [2, 3]}
      iex(1)>  Rotary.advance(Zippy.ZList.from_list([1,2,3]), -1)
      {[2, 1], [3]}
      iex(2)>  Rotary.advance(Zippy.ZList.from_list([1,2,3]), -100)
      {[2, 1], [3]}
  """
  def advance(zl, n)

  def advance(zl, 0), do: zl

  def advance({pre, []}, 1) do
    # at end of list, must start from beginning and advance
    Z.next({[], Enum.reverse(pre)})
  end

  def advance(zl, 1) do
    Z.next(zl)
  end

  def advance(zl, n) when n > 1 do
    advance(advance(zl, 1), n - 1)
  end

  def advance({[], post}, -1) do
    # at start of list, must go to end then go backwards
    Z.prev({Enum.reverse(post), []})
  end

  def advance(zl, -1) do
    Z.prev(zl)
  end

  def advance(zl, n) when n < -1 do
    advance(advance(zl, -1), n + 1)
  end

end
