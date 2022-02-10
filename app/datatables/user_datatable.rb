class UserDatatable < AjaxDatatablesRails::ActiveRecord

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      name: { source: "User.name", cond: :like, searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        id: record.id,
        name: record.name
      }
    end
  end

  def additional_data
    {
      foo: 'bar'
    }
  end

  def get_raw_records
    # insert query here
    User.all
  end

end
