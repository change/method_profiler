class Petition
  def self.hay
  end

  def self.guys
    "sup"
  end

  def foo
  end

  def bar
  end

  def baz
    "blah"
  end

  def method_with_implicit_block
    yield "implicit"
  end

  def method_with_explicit_block(&block)
    block.call "explicit"
  end

  def method_with_implicit_block_and_args(*args)
    yield args
  end

  def method_with_explicit_block_and_args(*args, &block)
    block.call args
  end
  
  private

  def shh
    "secret"
  end
end
