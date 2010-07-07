class Admin::PagesController < Admin::BaseController

  def index
    @pages = Plongo::Page.all(:order => 'name ASC')
  end
  
  def edit
    @page = Plongo::Page.find(params[:id])
  end
  
  def update
    @page = Plongo::Page.find(params[:id])
    
    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page updated with success'
        format.html { redirect_to edit_admin_page_url(@page) }
      else
        flash.now[:error] = "Page not updated"
        format.html { render :action => 'edit' }
      end
    end
  end
  
  def destroy
    @page = Plongo::Page.find(params[:id])
    
    @page.destroy
    
    flash[:notice] = 'Page deleted with success'
    
    redirect_to admin_pages_url
  end

end