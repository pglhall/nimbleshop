class Object
  def must_be_like other
    gsub(/\s+/, ' ').strip.must_equal other.gsub(/\s+/, ' ').strip
  end

  def must_have_same_elements other
    a1 = self
    a2 = other
    a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
    a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }
    a1h.must_equal a2h
  end

  def assert_must_have_same_elements obj1, obj2
    a1 = obj1
    a2 = obj2
    a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
    a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }
    a1h.must_equal a2h
  end

end
