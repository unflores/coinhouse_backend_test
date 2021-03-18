# model_class is the class of a model
# clauses is a series of hashes

=begin
QueryBuilder.new(Event)
  .with_name('fredrick')
  .at_location('some place')
  .with_speaker('johnson')
  .execute
=end
class QueryBuilder

  def initialize(model_class)
    @model_class = model_class
    @clauses = clauses
  end

  def with_name(name)
  end

  def at_location(location)
  end

  def with_speaker(speaker)
  end

  def clauses
  end

  def execute
  end

  private

  attr_reader :model_class, :clauses

end
