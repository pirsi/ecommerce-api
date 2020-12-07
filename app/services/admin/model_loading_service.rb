module Admin  
  class ModelLoadingService
    attr_reader :records, :pagination

    def initialize(searchable_model, params = {})
      @searchable_model = searchable_model
      @params = params || {}
      @records = []
      @pagination = { page: @params[:page].to_i, length: @params[:length].to_i }
    end

    def call
      normalize_pagination_params
      filtered = @searchable_model.search_by_name(@params.dig(:search, :name)
      @records = filtered.order(@params[:order].to_h)
                         .paginate(@pagination[:page], @pagination[:length])
      
      total_pages = (filtered.count / @pagination[:length].to_f).ceil
      @pagination.merge!(total: filtered.count, total_pages: total_pages)
    end

    private

    def normalize_pagination_params
      @pagination[:page]   = @searchable_model.model::DEFAULT_PAGE if @paginate[:page]   <= 0
      @pagination[:length] = @searchable_model.model::MAX_PER_PAGE if @paginate[:length] <= 0
    end
  end
end