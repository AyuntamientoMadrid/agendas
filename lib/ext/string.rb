class String
    def custom_titleize
        excluded = ["el", "la", "de", "del", "y", "a", "e"]
        phrase = self.downcase.capitalize!.split(" ").map {|word|
            if excluded.include?(word)
                word
            else
                word.capitalize
            end
        }.join(" ")
        phrase
    end
end
