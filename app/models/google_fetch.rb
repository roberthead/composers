require 'mechanize'

class GoogleFetch
  HEADER_ROW = 'page_name,google_results_count'
  RESULTS_REGEX = /About\s+(.+?)\s+results/i

  attr_accessor :composer
  attr_accessor :agent

  def initialize(composer)
    @composer = composer
    @agent = Mechanize.new
  end

  def fetch!
    name_count = mechanize_results_for_name(composer.name)
    short_name_count = mechanize_results_for_name(composer.short_name)
    total = Integer(name_count) + Integer(short_name_count)
    puts "#{composer.name} google results count: #{total}"
    GoogleCount.create(composer: composer, results_count: total)
  rescue
    puts "Unable to fetch google results count for #{composer.name}"
    nil
  end

  private

  def mechanize_results_for_name(name)
    sleep rand(3) + 1
    page = agent.get('https://www.google.com/')
    google_form = page.form('f')
    google_form.q = "\"#{name}\" composer"
    page = agent.submit(google_form)
    page.search("#resultStats").text.scan(RESULTS_REGEX)[0][0].gsub(',', '_').to_i
  rescue
    puts "Unable to fetch google results count for #{name}"
    nil
  end
end
