class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :order,              null: false
      t.belongs_to :product,            null: false
      t.belongs_to :variant,            null: true
      t.string     :variant_info,       null: true
      t.integer    :quantity,           null: false
      t.string     :product_name,       null: false
      t.text       :product_description
      t.decimal    :product_price,      null: false, precision: 8, scale: 2

      t.timestamps
    end

    # In line_items variant_id might or might not be NULL. This makes it difficult to have standard unique index. Hence
    # here partial index is being used. Read more about parital index at
    # http://www.postgresql.org/docs/8.0/static/indexes-partial.html
    #
    # To the extent I know MySQL does not have a clean support for partial index.
    #
    # Here are the rules
    # - if variant_id is NULL then product_id alone should be unique .
    # - if variant_id is not NULL then combination for product_id and variant_id should be unique .
    #
    # Code below still leaves one unresolved issue. It is possible to have following records. If anyone
    # has a solution to the below problem then let me know.
    #
    #  product_id | variant_id |
    #  100        | 200        |
    #  100        | NULL       |
    #
    if ActiveRecord::Base.connection.adapter_name == "PostgreSQL__"
      sql = %Q{
        CREATE UNIQUE INDEX line_items_product_id_variant_id_idx ON line_items (product_id, variant_id);
      }
      ActiveRecord::Base.connection.execute(sql)
      # Above line makes the combination of product_id and variant_id unique. However if variant_id is NULL
      # then same product_id is allowed since two NULLs are not same. Next parital index is applied to fix
      # this issue.
      sql = %Q{
        CREATE UNIQUE INDEX line_items_product_id_variant_id_null_idx
        ON line_items (product_id)
        WHERE variant_id IS NULL;
      }
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end
