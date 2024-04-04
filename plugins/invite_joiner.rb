#	IRC Cinch Bot InviteJoiner Plugin
#	by danielegt2
#	Somewhat fun way to allow the bot to join channels on invite
#	14/03/2015

require 'cinch'

module Cinch::Plugins
	class InviteJoiner
		include Cinch::Plugin
		
		def initialize(*args)
			super
			# Set the owner of the bot and his channel
			@owner_nick = ""
			@owner_channel = "#"
			
			@bot_nick = bot.nick
			@permission_asked = false
			@asked_channel = nil

			# Give the bot permission to join
			@positive_answers = [
				"yeh", "ok", "sure", "yeah", "yes", "kk", "go on",
				"why not", "maybe this time", "don't be too late",
				"come back for dinner", "go", "join them"
			]
			# Don't give permission
			@negative_answers = [
				"no", "nope", "noep", "noep lol", "lolno", "fuck no",
				"you wish", "stfu", "not this time", "no they're assholes",
				"hell no"
				
			]

			# Possible replies by the bot in case given permission
			@positive_responses = [
				"Yay!", "Thanks dad! <3", "Woot!", "Awesome!", "I'm going in...",
				"I'll be good!"
			]
			# Possible replies by the bot in case not given permission
			@negative_responses = [
				"Okay :(", ":'(", "Asshole.", "Fine.", "You never loved me anyway.",
				"Whatever.", "I didn't want to anyway.", "They probably didn't have cookies anyway.",
				"I suppose I could've been exploited sexually."
			]
		end

		listen_to :invite,  :method => :join_on_invite
		def join_on_invite(message)
			# If we haven't asked for permission yet
			if @permission_asked == false
				@asked_channel = message.channel
				if message.user.nick == @owner_nick
					bot.join(@asked_channel)
				else
					Channel(@owner_channel).send("Hey #{@owner_nick}, #{message.user.nick} wants me to join #{@asked_channel}, can I go?")
					@permission_asked = true
				end
			end
		end

		listen_to :message, :method => :deal_with_responses
		def deal_with_responses(message)
			# Should we do anything?
			return unless @permission_asked == true
			return unless message.channel == @owner_channel
			return unless message.user.nick == @owner_nick
			# Were we shown green light?
			unless message.message.scan(/^(#{@positive_answers.join('|')}) (#{@bot_nick})/i).empty?
				Channel(@owner_channel).send(@positive_responses[rand(@positive_responses.size)])
				bot.join(@asked_channel)
				@permission_asked = false
				@asked_channel = nil
				return
			end
			# No?
			unless message.message.scan(/^(#{@negative_answers.join('|')}) (#{@bot_nick})/i).empty?
				Channel(@owner_channel).send(@negative_responses[rand(@negative_responses.size)])
				@permission_asked = false
				@asked_channel = nil
				return
			end
		end
	end
end
