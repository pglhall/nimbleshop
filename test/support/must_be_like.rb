module M

  def assert_must_be_like a, other
    assert_equal a.gsub(/\s+/, ' ').strip, other.gsub(/\s+/, ' ').strip
  end

  def assert_sanitized_equal a, other
    _a = a.gsub(/\W/, ' ').gsub(/\s/, '').strip
    _other = other.gsub(/\W/, ' ').gsub(/\s/, '').strip
    assert_equal _a, _other
  end

  def assert_must_have_same_elements obj1, obj2
    a1 = obj1
    a2 = obj2
    a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
    a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }
    assert_equal a1h, a2h
  end
end

class ActiveSupport::TestCase
  include M
end
