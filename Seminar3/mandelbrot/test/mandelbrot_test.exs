defmodule MandelbrotTest do
  use ExUnit.Case
  doctest Mandelbrot

  test "greets the world" do
    assert Mandelbrot.hello() == :world
  end
end
