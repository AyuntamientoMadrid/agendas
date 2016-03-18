class String
    def custom_titleize
        self.capitalize!
        excluded = ["el", "la", "de", "del", "y", "a", "e"]
        phrase = self.split(" ").map {|word|
            word.capitalize unless excluded.include?(word)
        }.join(" ")
        phrase
    end
end
