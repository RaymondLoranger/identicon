defmodule Identicon.Drawer do
  use PersistConfig

  alias Identicon.Image

  @identicon_dir Application.get_env(@app, :identicon_dir)
  @identicon_pgm Application.get_env(@app, :identicon_pgm)

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
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(squares, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    binary = :egd.render(image)
    :ok = :egd.destroy(image)
    binary
  end

  @spec show_image(binary, String.t()) :: :ok | {:error, File.posix()}
  defp show_image(image, file_name) do
    file_path = Path.expand("#{@identicon_dir}#{file_name}.png")
    cmd = String.to_charlist(~s[#{@identicon_pgm} "#{file_path}"])

    with :ok <- File.mkdir_p(@identicon_dir),
         :ok <- File.write(file_path, image),
         pid when is_pid(pid) <- spawn(:os, :cmd, [cmd]),
         do: :ok,
         else: ({:error, reason} -> {:error, reason})
  end
end
