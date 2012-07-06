module M

  def assert_must_be_like a, b
    assert_equal a.gsub(/\s+/, ' ').strip, b.gsub(/\s+/, ' ').strip
  end

  def assert_sanitized_equal a, b
    a1 = a.gsub(/\W/, ' ').gsub(/\s/, '').strip
    b2 = b.gsub(/\W/, ' ').gsub(/\s/, '').strip
    assert_equal a1, b2
  end

  def assert_sorted_equal a, b
    assert_equal a.sort, b.sort
  end

  def assert_must_have_same_records a, b
    assert_sorted_equal a.map(&:id), b.map(&:id)
  end
end

class ActiveSupport::TestCase
  include M
end
