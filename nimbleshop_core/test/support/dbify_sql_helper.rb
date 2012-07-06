module DbifySqlHelper

  def dbify_sql(sql)
    case ActiveRecord::Base.connection.adapter_name
    when "SQLite"
      sql
    when "PostgreSQL"
      sql.gsub('LIKE', 'ILIKE')
    end
  end

end
