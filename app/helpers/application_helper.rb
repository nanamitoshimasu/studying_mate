module ApplicationHelper
  def format_duration(seconds)
    return '00 00' unless seconds

    hours = (seconds.abs / 3600).floor
    minutes = ((seconds.abs % 3600) / 60).floor

    formatted_hours = hours.to_s.rjust(2, '0')
    formatted_minutes = minutes.to_s.rjust(2, '0')

    formatted_time = "#{seconds < 0 ? '-' : ''}#{formatted_hours} #{formatted_minutes}"
  end
end
