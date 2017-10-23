require "dotenv"
Dotenv.load

require "telegram_bot"
require "oxford_dictionary"
require "./definebot/*"

TOKEN = ENV["BOT_TOKEN"]

module Definebot
  class Bot < TelegramBot::Bot
    include TelegramBot::CmdHandler

    macro do_cmd(command, handler) cmd {{command}} { |msg, params| {{handler}} msg, params } end

    def initialize
      super("MasterDefineBot", TOKEN)

      @dict = OxfordDictionary.new(ENV["OXFORD_APP_ID"], ENV["OXFORD_APP_KEY"])
    
      do_cmd "help", help_command
      do_cmd "start", help_command
      do_cmd "define", define_command
      do_cmd "examples", not_ready_yet
      do_cmd "pronounce", not_ready_yet
      do_cmd "synonyms", not_ready_yet
      do_cmd "antonyms", not_ready_yet
      do_cmd "translate", not_ready_yet
    end

    def not_ready_yet(msg, params)
      message = "This command is not yet ready for use. Please check back later."
      send_message msg.from.not_nil!.id, message
    end

    def help_command(msg, params)
      message = %q{Welcome to DefineBot!!! 😊😊😊

I know all of the words in the Oxford Dictionary, so I guess you could say I'm kinda smart. I come with several commands for defining words, finding synonyms and antonyms, translating and more.

Here are all of the commands I know:

/help - Show this message again
/define \[word] - Define a word
/examples \[word] - Show examples of a word being used
/pronounce \[word] - Show how a word is supposed to be pronounced
/synonyms \[word] - List known synonyms of a word
/antonyms \[word] - List known antonyms of a word

Lastly is /translate, which for now only works while replying to another message. Reply with "/translate from\_language to\_language" to translate something that someone else has said. If to language is not incuded the language will be your set language (it it's supported).

Ex. */translate es en* will translate from English to Spanish. For supported languages see [the Oxford API Documentation](https://developer.oxforddictionaries.com/documentation/languages).
}
      send_message msg.from.not_nil!.id, message, parse_mode: "markdown"
    end

    def define_command(msg, params)
      from_id = msg.from.not_nil!.id
      word = @dict.define(params[0]) unless params.empty?

      if (word.nil?)
        params[0] = "nothing"
        word = @dict.define("nothing")
      end

      definitions = Definition.from_result(word.not_nil!)
      
      def_prty = definitions.map_with_index { |d| d.pretty(true) }.join("\n\n")

      send_message from_id, def_prty, parse_mode: "markdown"
    end
  end
end

bot = Definebot::Bot.new
bot.polling