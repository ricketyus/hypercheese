require_dependency 'search'

class SearchController < ApplicationController
  # GET /
  def index
    @start_time = Time.new
    @query = params[:q] || ''

    @search = Search.new @query
    @items = @search.items
    @invalid = @search.invalid
    @count = @items.count

    if @search.sort_by == :taken
      @sections = Rails.cache.fetch( "sections-#@query-#{@count}" ) do
        sections = {}
        prev_date = nil
        @items.all.each_with_index do |item,index|
          date = item.taken.strftime( "%e %b %Y" )
          if prev_date != date
            sections[index] = date
            prev_date = date
          end
        end
        sections
      end
    end

    @title = "#@query - HyperCheese Search" unless @query.empty?
  end

  # GET /search/results
  def results
    @items = Search.new(params[:q]).items
    @items = @items.all :limit => params[:limit], :offset => params[:offset]
    @res = @items.map { |item|
      item.id
    }
    render json: @res
  end

  # GET /search/advanced
  def advanced
    @tags = Tag.where( "item_count > 0" ).order( "item_count desc" )
    @title = "Advanced Cheese"
  end

  # GET /search/advanced/update
  def update_advanced
    @items = Search.execute params[:q]

    ids = []
    @items.each do |item|
      ids << item.id
    end

    tags = {}

    render json: { :count => @items.count, :tags => tags }
  end

  # POST /search/advanced
  def advanced_search
    parts = []

    if params[:tag]
      tags = []
      params[:tag].each do |id|
        tag = Tag.find id.to_i
        tags << tag.label
      end
      parts << tags.join( ', ' )
    end


    if params[:orientation] != 'both'
      parts << 'orient:' + params[:orientation].downcase
    end

    parts.unshift 'any' if !params[:all]
    parts.unshift 'only' if params[:only]

    if params[:type] != 'all'
      parts << 'type:' + params[:type]
    end

    if params[:by] != 'taken'
      parts << 'by:' + params[:sort]
    end

    parts << 'reverse' if params[:reverse]

    redirect url_for( :search_index, :q => parts.join( ' ' ) )
  end

  private
  def map_items
    item_ids = @items.map do |i|
      i.id
    end

    @tag_map = {}
    ItemTag.where( :item_id => item_ids ).each do |it|
      @tag_map[it.item_id] ||= {}
      @tag_map[it.item_id][it.tag_id] = true
    end

    @tag_order = []
    @tag_icons = {}
    Tag.order( "item_count desc" ).each do |tag|
      @tag_order << [ tag.label, tag.id ]
      next unless tag.icon
      @tag_icons[ tag.id ] = image_path tag.icon.resized_url( 'square' )
    end
  end
end
