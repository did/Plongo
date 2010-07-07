Rails::Generator::Commands::Create.class_eval do
  def route_resource(*resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.resource #{resource_list}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n map.resource #{resource_list}\n"
      end
    end
  end
  
  def route_name(name, path, route_options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    
    logger.route "map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
      end
    end
  end
  
  def insert_into(file, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend]
      gsub_file file, /^(class .+|module .+|ActionController::Routing::Routes.draw do \|map\|)$/ do |match|
        "#{match}\n #{line}"
      end
    end
  end
  
  def insert_before(file, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend]
      gsub_file file, /^(Spec::Runner.configure do \|config\|)$/ do |match|
        "#{line}\n #{match}"
      end
    end
  end
  
  def append_into(file, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend]
      append_file(file, line)
    end
  end
  
  def insert_close_to(file, regexp, line)
    logger.insert "#{line} into #{file}"
    unless options[:pretend]
      gsub_file file, Regexp.new(regexp) do |match|
        "#{match}\n #{line}"
      end
    end
  end
  
  protected
  
  def append_file(relative_destination, line)
    path = destination_path(relative_destination)
    content = File.read(path) + "\n #{line}"
    File.open(path, 'wb') { |file| file.write(content) }
  end
end
 
Rails::Generator::Commands::Destroy.class_eval do
  def route_resource(*resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    look_for = "\n map.resource #{resource_list}\n"
    logger.route "map.resource #{resource_list}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
    end
  end
  
  def route_name(name, path, route_options = {})
    look_for = "\n map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    logger.route "map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{look_for})/mi, ''
    end
  end
  
  def insert_into(file, line)
    logger.remove "#{line} from #{file}"
    unless options[:pretend]
      gsub_file file, "\n #{line}", ''
    end
  end
  
  def insert_before(file, line)
    insert_into(file, line)
  end
  
  def insert_close_to(file, regexp, line)
    insert_into(file, line)
  end
end
 
Rails::Generator::Commands::List.class_eval do
  def route_resource(*resources)
    resource_list = resources.map { |r| r.to_sym.inspect }.join(', ')
    logger.route "map.resource #{resource_list}"
  end
  
  def route_name(name, path, options = {})
    logger.route "map.#{name} '#{path}', :controller => '{options[:controller]}', :action => '#{options[:action]}'"
  end
  
  def insert_into(file, line)
    insert_into(file, line)
  end
  
  def insert_before(file, line)
    insert_into(file, line)
  end
  
  def insert_close_to(file, line)
    insert_into(file, line)
  end
end