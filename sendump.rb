require 'mechanize'
require 'logger'
require 'pry'

log = Logger.new(STDOUT)
log.level = Logger::INFO

a = Mechanize.new do |agent|
    agent.user_agent_alias = 'Mac Safari'
    agent.log = log
end

initial_page = 'http://raw.senmanga.com/Mitsuboshi-Colors/13/1'

a.get(initial_page) do |page|
chapter = page.uri.to_s.split('/')[-2]
log.info("Ripping chapter #{chapter}...")
    loop do
        page_num = page.uri.to_s.split('/')[-1]
        next_page = page.link_with(:text => 'Next Page')
        log.info("Fetching page #{page_num}...")
        image = page.image_with(id:'picture').fetch
        image.save(page.uri.to_s.split('/')[-3..-1].join('/') + '.jpg')
        break unless next_page
        page = next_page.click
    end
end
