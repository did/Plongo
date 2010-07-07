require File.expand_path(File.dirname(__FILE__) + "/insert_commands.rb")

class PlongoAdminGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.directory "app/controllers/admin"
      m.template "controller.rb", "app/controllers/admin/pages_controller.rb"
      
      m.directory "app/helpers/admin"
      m.template "helper.rb", "app/helpers/admin/pages_helper.rb"
      
      m.directory "app/views/admin/pages"
      m.template "index.html.erb", "app/views/admin/pages/index.html.erb"
      m.template "edit.html.erb", "app/views/admin/pages/edit.html.erb"
      
      m.directory "public/stylesheets/admin"
      m.template "plongo.css", "public/stylesheets/admin/plongo.css"
      m.directory "public/javascripts/admin"
      m.template "plongo.js", "public/javascripts/admin/plongo.js"
      m.directory "public/javascripts/admin/plugins"
      m.template "delegate.js", "public/javascripts/admin/plugins/delegate.js"
      
      m.insert_close_to 'config/routes.rb', 'admin.resource :session', <<-END
    admin.resources :pages
      END
      
    end
  end
  
  def assets(manifest)
    Dir[File.join(source_path('public'), '**/**')].each do |file|
      if File.directory?(file)
        manifest.directory relative_public_path(file)
      else
        manifest.file relative_public_path(file), relative_public_path(file)
      end
    end
  end
  
  def relative_public_path(file)
    File.join('public', file.gsub(source_path('public'), ''))
  end
  
end