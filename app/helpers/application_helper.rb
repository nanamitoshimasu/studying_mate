module ApplicationHelper
  def format_duration(seconds)
    return "00 00" unless seconds
    
    hours = (seconds / 3600).floor
    minutes = ((seconds % 3600) / 60).floor
    "#{hours.to_s.rjust(2, '0')} #{minutes.to_s.rjust(2, '0')}"
  end
end
