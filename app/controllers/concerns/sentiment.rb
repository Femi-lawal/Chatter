class Sentiment
  def initialize
    # Create an instance for usage
    @analyzer = Sentimental.new

    # Load the default sentiment dictionaries
    @analyzer.load_defaults
  end

  def analyze(word)
    @analyzer.sentiment word
  end

end