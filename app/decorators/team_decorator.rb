class TeamDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    object.thumbnail.presence || 'team_thumbnail_default.jpg'
  end

  def self.options_for_select
    [
      ["10", 01],
      ["20", 01],
      ["30", 02],
      ["40", 02],
      ["50", 03],
      ["60", 03],
      ["70", 04],
      ["80", 04],
      ["90", 05],
      ["100", 05],
      ["110", 06],
      ["120", 06],
      ["130", 07],
      ["140", 07],
      ["150", 08],
      ["160", 08],
      ["170", 09],
      ["180", 09],
      ["190", 10],
      ["200", 10],
      ["210", 11],
      ["220", 11],
      ["230", 12],
      ["240", 12],
      ["250", 13],
      ["260", 13],
      ["270", 14],
      ["280", 14],
      ["290", 15],
      ["300", 15],
      ["310", 16],
      ["320", 16],
      ["330", 17],
      ["340", 17],
      ["350", 18],
      ["360", 18],
      ["370", 19],
      ["380", 19],
      ["390", 20],
      ["400", 20]
    ]
  end
end
