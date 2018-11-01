defmodule Identicon.Drawer do
  use PersistConfig

  alias Identicon.Image

  @folder Application.get_env(@app, :target_folder)
  @prog Application.get_env(@app, :program)
  @sep Application.get_env(@app, :separator)

  @spec depict(String.t()) :: :ok | {:error, File.posix()}
  def depict(input) do
    input
    |> Image.build()
    |> draw_image()
    |> show_image(input)
  end

  ## Private functions

  @spec draw_image(Image.t()) :: binary
  defp draw_image(%Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    binary = :egd.render(image)
    :ok = :egd.destroy(image)
    binary
  end

  @spec show_image(binary, String.t()) :: :ok | {:error, File.posix()}
  defp show_image(image, file_name) do
    # Folder(s) may already exist(s)...
    with _any <- File.mkdir_p(@folder),
         file <- "#{@folder}#{@sep}#{file_name}.png",
         :ok <- File.write(file, image),
         cmd <- @prog ++ ' "' ++ String.to_charlist(file) ++ '"',
         _pid <- spawn(:os, :cmd, [cmd]),
         do: :ok,
         else: (error -> error)
  end
end
