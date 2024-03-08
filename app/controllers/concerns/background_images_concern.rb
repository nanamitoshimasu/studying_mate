module BackgroundImagesConcern
  extend ActiveSupport::Concern

  private

  def set_background_images
    @images = [
      "top-01.jpg",
      "top-02.jpg",
      "top-03.jpg",
      "top-04.jpg",
      "top-05.jpg",
      "top-06.jpg",
      "top-07.jpg",
      "top-08.jpg",
      "top-09.jpg"
    ]
  end
end
