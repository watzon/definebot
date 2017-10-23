module Definebot
    class Definition
        property :word, :part_of_speech, :definitions

        def initialize(@word : String, @definitions = [] of String, @part_of_speech : String? = nil)
        end

        def pretty(markdown : Bool = false)
            definitions = @definitions.map_with_index! { |d, i| "#{i + 1}) #{d}" }.join("\n")
            pos = @part_of_speech
            res = ""

            if markdown
                res += "*#{@word}*"
                res += " _#{pos.downcase}_" unless pos.nil?
            else
                res += @word
                res += " - #{pos.downcase}" unless pos.nil?
            end

            res += "\n#{definitions}"
            res 
        end

        def self.from_result(res : Types::Result)
            definitions = [] of Definition
            res.results.each do |result|
                result.lexicalEntries.each do |le|
                    d = Definition.new(word: result.word, part_of_speech: le.lexicalCategory)
                    le.entries.each do |entry|
                        entry.senses.each do |sense|
                            d.definitions += sense.definitions unless sense.definitions.nil?
                        end
                    end
                    definitions.push(d)
                end
            end
            definitions
        end
    end
end