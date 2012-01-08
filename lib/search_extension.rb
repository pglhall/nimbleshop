module SearchExtension
  def to_search_sql
    set_indexes
    search_proxy = merge_joins.where(merge_where)
    search_proxy = search_proxy.project(Arel.sql("products.*"))
    search_proxy.to_sql
  end

  def search
    Product.find_by_sql(to_search_sql)
  end

  private

  def set_indexes
    each_with_index { | condition, index | condition.index = index }
  end

  def merge_joins
    inject(Product.arel_table) { | p, condition | condition.join(p) }
  end

  def merge_where
    inject(nil) { | p, condition | condition.where(p) }
  end
end
