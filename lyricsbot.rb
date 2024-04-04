#	IRC Cinch Bot Lyrics LyricsBot
#	by danielegt2
#	14/03/2015

require 'cinch'
load "plugins/lyrics.rb"
load "plugins/invite_joiner.rb"

bot = Cinch::Bot.new do
	configure do |c|
		c.nick 		= 'LyricsBot'
		c.realname 	= 'LyricsBot'
		c.user 		= 'LyricsBot' 
		c.server 	= 'irc.rizon.net'
		c.channels	= ['#testbot']
		c.plugins.plugins = [Cinch::Plugins::Lyrics, Cinch::Plugins::InviteJoiner]
	end
end

bot.start
