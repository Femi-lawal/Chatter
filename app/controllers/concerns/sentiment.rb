class Sentiment
  def initialize
    # Create an instance for usage
    @analyzer = Sentimental.new

    # Load the default sentiment dictionaries
    @analyzer.load_defaults
  end

  def analyze(sentiment)
    @analyzer.sentiment sentimer
  end

end