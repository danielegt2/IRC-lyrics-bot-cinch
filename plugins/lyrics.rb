#	IRC Cinch Bot Lyrics Plugin
#	by danielegt2
#	Sends requested lyrics
#	14/03/2015

require 'cinch'
require 'lyricfy'

module Cinch::Plugins
	class Lyrics
		include Cinch::Plugin
		
		def initialize(*args)
			super
			@bot_nick = bot.nick
		end
		
		match(/help (#{@bot_nick})/, method: :help)
		
		def help(m)
			m.reply "Usage !lyrics <artist> - <title>"
		end
		
		match(/lyrics (.+)/, method: :ly_main)
		
		def ly_main(m, query)
			m.reply "Anybody wants some lyrics?"
			help(m)
			m.user.notice "I will immediately search for #{query}, wait a second"
			info = analyse(query)
			if info
				lyrics = search(info[0], info[1])
				if lyrics
					m.user.notice "Yeah! I found them! I'm sending them to you!"
					m.user.send "*** Here are the lyrics for #{info[1]} by #{info[0]} ***\n \n"
					lyrics.lines.each do |ly|
						m.user.send ly
					end
					m.user.send "\n \n*** End of lyrics ***"
				else
					m.user.notice "I'm very sorry I couldn't find the lyrics ;_;"
				end
			else
				m.user.notice "You didn't write correctly!\nUsage !lyrics <artist> - <title>"
			end
      end
      
      def search (artist, title)
			fetcher = Lyricfy::Fetcher.new
			fetcher.search(artist, title)
      end
      
      def analyse (query)
			if query['-']
				r = query.lines('-')
				r[0]['-'] = ''
				r[0] = r[0].strip.split.map(&:capitalize).join(' ')
				r[1] = r[1].strip.split.map(&:capitalize).join(' ')
			else
				r = nil
			end
			r
      end
	end
end
