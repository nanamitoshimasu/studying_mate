module ApplicationHelper
  def format_duration(seconds)
    return '00 00' unless seconds

    hours = (seconds.abs / 3600).floor
    minutes = ((seconds.abs % 3600) / 60).floor

    formatted_hours = hours.to_s.rjust(2, '0')
    formatted_minutes = minutes.to_s.rjust(2, '0')

    formatted_time = "#{seconds < 0 ? '-' : ''}#{formatted_hours} #{formatted_minutes}"
  end

  def default_meta_tags
    {
      site: 'やる気の森',
      title: '学習時間を記録し森林を増やして絶滅危惧種を救おう！',
      reverse: true,
      charset: 'utf-8',
      description: '同じ学習目的のプログラミング学習者同士を繋げて、学習時間を記録するサービスです。',
      keywords: 'やる気モリモリ,プログラミング学習,学習時間記録,森林,絶滅危惧種',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('yarumori_OGP.png'),
        local: 'ja-JP'
      },
      
      twitter: {
        card: 'summary_large_image',
        site: '@hllspd_73',
        image: image_url('yarumori_OGP.png')
      }
    }
  end
end
