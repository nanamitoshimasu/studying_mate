module BackgroundImagesConcern
  extend ActiveSupport::Concern

  private

  def set_background_images
    @images = [
      "top-01.webp",
      "top-02.webp",
      "top-03.webp",
      "top-04.webp",
      "top-05.webp",
      "top-06.webp",
      "top-07.webp",
      "top-08.webp",
      "top-09.webp"
    ]
  end
end
