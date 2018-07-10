class Clippify
  def self.logger
    @@logger ||= Logger.new($stdout)
  end
end
