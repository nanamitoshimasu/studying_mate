class TeamDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    object.thumbnail.presence || 'team_thumbnail_default.jpg'
  end
end
