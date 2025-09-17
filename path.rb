require_relative 'posts_controller'
require "active_support/core_ext/string/inflections"

class Path
  def get_call(env)
    path_parts = env[:path].split("/").reject(&:empty?) 
    resource = path_parts[0]                              
    id = path_parts[1]                                    

    if id =~ /^\d+$/
      call_show(env, resource, id)
    else
      call_index(env, resource)
    end
  end

  def call_index(env, resource)
    Object.const_get("#{resource.camelize}Controller").new(env).index
  end

  def call_show(env, resource, id)
    Object.const_get("#{resource.camelize}Controller").new(env).show(id)
  end
end
