class TeamDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    object.thumbnail.presence || 'team_thumbnail_default.jpg'
  end

  def self.options_for_select
    [
      ['ゴリラ', 10],
      ['ワニ', 20],
      ['トナカイ', 30],
      ['ゾウ', 40],
      ['ワオキツネザル', 50],
      ['サイ', 60],
      ['オオアリクイ', 70],
      ['オランウータン', 80],
      ['パンダ', 90],
      ['レッサーパンダ', 100],
      ['コアラ', 110],
      ['トラ', 120],
      ['カワウソ', 130],
      ['マレーバク', 140],
      ['ラッコ', 150],
      ['ジュゴン', 160],
      ['ジンベイザメ', 170],
      ['セイウチ', 180],
      ['シロナガスクジラ', 190],
      ['シロクマ', 200]
    ]
  end
end
