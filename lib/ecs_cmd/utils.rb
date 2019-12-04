module EcsCmd
  module Utils
    def self.parse_image_name(image)
      regex = /^([a-zA-Z0-9\.\-]+):?([0-9]+)?\/?([a-zA-Z0-9\._\-]+)(\/[\/a-zA-Z0-9\._\-]+)?:?([a-zA-Z0-9\._\-]+)?$/
      raise 'invalid image supplied, please verify correct image format' unless regex.match(image)
      if regex.match(image)[5].nil? || regex.match(image)[5] == false
        regex.match(image)[1]
      elsif regex.match(image)[4].nil? || regex.match(image)[4] == false
        regex.match(image)[3]
      else
        regex.match(image)[4].gsub(/\//, '')
      end
    end

    def self.parse_image_tag(image); end
  end
end

class String
  def tokenize
    self.
      split(/\s(?=(?:[^'"]|'[^']*'|"[^"]*")*$)/).
      select {|s| not s.empty? }.
      map {|s| s.gsub(/(^ +)|( +$)|(^["']+)|(["']+$)/,'')}
  end
end