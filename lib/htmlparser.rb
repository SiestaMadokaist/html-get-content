require 'memoist'
class HTMLParser
  extend Memoist

  ReversedParser = /(?<after>[^>]*)>(?<tag>[^\/]+)\/<(?<body>.*?)>(?<tag_attr>[^>]*)\k<tag><(?<before>.*)/
  attr_reader(:raw_string)
  def initialize(raw_string)
    @raw_string = raw_string.gsub("\n", "")
  end

  def reversed
    @raw_string.reverse
  end
  memoize(:reversed)

  def reverse_parsed
    ReversedParser.match(reversed)
  end
  memoize(:reverse_parsed)

  def parsed
    names = reverse_parsed.names
    captures= names.map(&:to_sym).zip(names.map{|name| reverse_parsed[name].reverse})
    Hash[captures]
  end

  def body
    parsed[:body].strip
  end

  def before
    parsed[:before].strip
  end

  def after
    parsed[:after].strip
  end

  def tag_attr
    parsed[:tag_attr]
  end

  def _clean_string
    "#{before} #{body} #{after}"
  end

  def _content
    HTMLParser.new(_clean_string.strip)
  end
  memoize(:_content)

  def content
    if(reverse_parsed)
      _content.content
    else
      self
    end
  end

  def content_string
    content.raw_string
  end

end

# html_text = "
# <body>
  # <p> this is a paragraph </p>
  # <ul>
    # <li class='hello-world'>
      # item1
    # </li>
    # <li class='hello-world'>
      # item2 > 3
    # </li>
  # </ul>
# </body>"
# html = HTMLParser.new(html_text)
