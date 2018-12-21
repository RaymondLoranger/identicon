defmodule Identicon.Drawer do
  use PersistConfig

  alias Identicon.Image

  @identicon_dir Application.get_env(@app, :identicon_dir)
  @identicon_pgm Application.get_env(@app, :identicon_pgm)
  @sep Application.get_env(@app, :sep)
  @square_size Application.get_env(@app, :square_size)
  @squares_across Application.get_env(@app, :squares_across)
  @squares_down Application.get_env(@app, :squares_down)

  @image_width @square_size * @squares_across
  @image_height @square_size * @squares_down

  @spec depict(String.t()) :: :ok | {:error, File.posix()}
  def depict(input) do
    input
    |> Image.build()
    |> draw_image()
    |> show_image(input)
  end

  ## Private functions

  @spec draw_image(Image.t()) :: binary
  defp draw_image(%Image{color: color, squares: squares}) do
    image = :egd.create(@image_width, @image_height)
    fill = :egd.color(color)

    Enum.each(squares, fn {top_left, bottom_right} ->
      :ok = :egd.filledRectangle(image, top_left, bottom_right, fill)
    end)

    binary = :egd.render(image)
    :ok = :egd.destroy(image)
    binary
  end

  @spec show_image(binary, String.t()) :: :ok | {:error, File.posix()}
  defp show_image(image, file_name) do
    file_path =
      "#{@identicon_dir}/#{file_name}.png"
      |> Path.expand()
      |> String.replace("/", @sep)

    cmd = String.to_charlist(~s[#{@identicon_pgm} "#{file_path}"])

    with :ok <- File.mkdir_p(@identicon_dir),
         :ok <- File.write(file_path, image),
         pid when is_pid(pid) <- spawn(:os, :cmd, [cmd]),
         do: :ok,
         else: ({:error, reason} -> {:error, reason})
  end
end
