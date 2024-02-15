class TeamDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    object.thumbnail.presence || 'team_thumbnail_default.jpg'
  end

  def self.options_for_select
    [
      %w[10 10],
      %w[20 20],
      %w[30 30],
      %w[40 40],
      %w[50 50],
      %w[60 60],
      %w[70 70],
      %w[80 80],
      %w[90 90],
      %w[100 100],
      %w[110 110],
      %w[120 120],
      %w[130 130],
      %w[140 140],
      %w[150 150],
      %w[160 160],
      %w[170 170],
      %w[180 180],
      %w[190 190],
      %w[200 200],
      %w[210 210],
      %w[220 220],
      %w[230 230],
      %w[240 240],
      %w[250 250],
      %w[260 260],
      %w[270 270],
      %w[280 280],
      %w[290 290],
      %w[300 300],
      %w[310 310],
      %w[320 320],
      %w[330 330],
      %w[340 340],
      %w[350 350],
      %w[360 360],
      %w[370 370],
      %w[380 380],
      %w[390 390],
      %w[400 400]
    ]
  end
end
