class AssistantsDataTable
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::OutputSafetyHelper
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, include_event=false, is_brief=false)
    @view = view
    @include_event = include_event
    @is_brief = is_brief
  end


  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Assistant.count,
        iTotalDisplayRecords: fetch_assistants(false).count,
        aaData: data
    }
  end


  def data
    assistants.map do |assistant|
      assistant
    end
  end


  private

  def assistants
    @assistants ||= fetch_assistants
  end

  def fetch_assistants(paginate=true)
    query = Assistant.all
    collection_params = [
        {
           :$project => {
               :_id => true,
               :name => true,
               :lastname => true,
               :hashcode => true,
               :event_id => true,
               :full_name => {:$concat => ["$name", " ", "$lastname"]}
           }
        }
    ]
    if @include_event
      collection_params << {
          :$lookup => {
              'from': "events",
              'localField': "event_id",
              'foreignField': "_id",
              'as': "event"
          }
      }
      collection_params << {  :$unwind => "$event" } #Para obtener primer elemento
    end
    if params[:search].present?
      searchRegex = /.*#{params[:search]}.*/i
      searchColumns = [
          {:name => searchRegex},
          {:lastname => searchRegex},
          {:hashcode => searchRegex},
          {:full_name => searchRegex}
      ]
      searchColumns << {:'event.name' => searchRegex} if @include_event
      collection_params << {
          :$match => {
              :$or => searchColumns
          }
      }
    end
    collection_params << { :$sort => { "#{sort_column}": sort_direction } }
    collection_params << { :$skip => (per_page * (page - 1))} if paginate
    collection_params << { :$limit => per_page } if paginate
    query = query.collection.aggregate(collection_params)
    query
  end

  def page
    params[:pageIndex].to_i + 1
  end

  def per_page
    params[:pageSize].to_i > 0 ? params[:pageSize].to_i : 10
  end

  def sort_column
    #columns = %w[assistants.folio data_assistants.value data_assistants.value data_assistants.value status_assistants.name assistants.id assistants.id]
    columns = %w[_id name lastname hashcode, event.name]
    column = columns[0]
    if params[:sortColumn].present? && columns.include?(params[:sortColumn])
      column = params[:sortColumn]
    end
    column
  end

  def sort_direction
    params[:sortDirection] == "desc" ? -1 : 1
  end
end
