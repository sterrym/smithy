require_dependency "smithy/application_controller"

module Smithy
  class PageContentsController < ApplicationController
    before_filter :load_page
    before_filter :load_page_content, :only => [ :edit, :update, :destroy, :preview ]
    before_filter :build_content_block, :only => [ :edit, :update ]
    before_filter :load_content_blocks, :only => [ :new, :create ]
    respond_to :html, :json

    def new
      @page_content = Smithy::PageContent.new(params[:page_content])
    end

    def create
      @page_content = Smithy::PageContent.new(params[:page_content])
      @page_content.page = @page
      @page_content.save
      respond_with @page_content do |format|
        format.html { @page_content.persisted? ? redirect_to(edit_page_content_path(@page.id, @page_content)) : render(:action => 'new') }
      end
    end

    def edit
      respond_with @page_content
    end

    def update
      @page_content = Smithy::PageContent.find(params[:id])
      @saved = @page_content.update_attributes(params[:page_content])
      flash.notice = "Your content was saved" if @saved
      respond_with @page_content do |format|
        format.html { @saved ? redirect_to(edit_page_path(@page.id)) : render(:action => "edit") }
      end
    end

    def destroy
      @page_content.destroy
      respond_with @page_content do |format|
        format.html { redirect_to edit_page_path(@page.id), :notice => "Your content was deleted from the page" }
      end
    end

    def preview
      respond_with @page_content do |format|
        format.html { render :text => @page_content.render, :layout => 'smithy/modal' }
      end
    end

    private
      def build_content_block
        unless @page_content.content_block.present?
          klass = "Smithy::#{@page_content.content_block_type.classify}".safe_constantize || @page_content.content_block_type.classify.safe_constantize
          if klass
            @page_content.content_block = klass.new
          end
        end
      end

      def load_content_blocks
        @content_blocks = Smithy::ContentBlock.all
      end

      def load_page
        @page = Smithy::Page.find(params[:page_id])
      end

      def load_page_content
        @page_content = Smithy::PageContent.find(params[:id])
      end

  end
end