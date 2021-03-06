require_dependency "smithy/base_controller"

class Smithy::ContentResourcesController < Smithy::BaseController
  before_filter :set_controller_path
  respond_to :html, :json

  helper_method :accessible_attributes
  helper_method :klass_name
  helper_method :klass_table_name
  helper_method :readable_attributes

  def index
    @records = find_records
    respond_with @records
  end

  def show
    @record = find_record
    respond_with @record
  end

  def new
    @record = new_record
    respond_with @record
  end

  def create
    @record = new_record
    @record.save
    flash.notice = "Your #{klass_name} was created" if @record.persisted?
    respond_with @record do |format|
      format.html { @record.persisted? ? redirect_to(:action => :index) : render(:action => 'new') }
    end
  end

  def edit
    @record = find_record
    respond_with @record
  end

  def update
    @record = find_record
    @saved = update_record(@record)
    flash.notice = "Your #{klass_name} was saved" if @saved
    respond_with @page_content do |format|
      format.html { @saved ? redirect_to(:action => :index) : render(:action => "edit") }
    end
  end

  def destroy
    @record = find_record
    @record.destroy
    flash.notice = "Your #{klass_name} was deleted"
    respond_with @record
  end

  private
    def filtered_params
      permitted_params.params_for klass.name.sub(/^Smithy::/, '').underscore
    end

    def klass
      # override to provide an object for each class
      raise "You must inherit from this Smithy::ContentResourcesController and provide a private #klass method"
    end

    def klass_name
      @klass_name ||= klass.name.sub(/^Smithy::/, '').titleize
    end

    def klass_table_name
      klass.name.sub(/^Smithy::/, '').underscore.pluralize
    end

    def new_record
      klass.new(filtered_params)
    end

    def find_record
      klass.find(params[:id])
    end

    def find_records
      klass.all
    end

    def set_controller_path
      @controller_path = self.class.superclass.name.sub(/Controller$/, '').deconstantize.underscore
    end

    def update_record(record)
      record.update_attributes(filtered_params)
    end

    def readable_attributes
      accessible_attributes
    end

    def accessible_attributes
      permitted_params.send("#{klass.name.sub(/^Smithy::/, '').underscore}_attributes".to_sym)
    end
end
