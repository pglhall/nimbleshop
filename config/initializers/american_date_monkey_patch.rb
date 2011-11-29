#http://stackoverflow.com/questions/6825048/how-to-make-assigning-an-american-formatted-date-string-into-a-date-variable-work
# Date.parse() with Ruby 1.9 is now defaulting to the European date style where the format is DD/MM/YYYY, not MM/DD/YYYY
# patch it to use US format by default
class Date
  class << self
    alias :euro_parse :_parse
    def _parse(str,comp=false)
      str = str.to_s.strip
      if str == ''
        nil
      elsif str =~ /^(\d{1,2})[-\/](\d{1,2})[-\/](\d{2,4})/
        year,month,day = $3.to_i,$1,$2
        date,*rest = str.split(' ')
        year += (year < 35 ? 2000 : 1900) if year < 100
        euro_parse("#{year}-#{month}-#{day} #{rest.join(' ')}",comp)
      else
        euro_parse(str,comp)
      end
    end
  end
end
