require 'faker'
require "active_support/inflector"
module SimpleValidation
    def self.included(base)
        base.extend(ClassMethods)
    end

    module ClassMethods
        def validates(attribute, options)
            @validators ||= {}
            @validators[attribute] ||= []
            @validators[attribute] << options

            define_method("valid_#{attribute}") do
                value = send(attribute)
                errors[attribute] ||= []

                if options[:presence] && (value.nil? || value.to_s.strip.empty?)
                    errors[attribute] << "can't be blank"
                end
            end
        end

        def _validators
            @validators || {}
        end
    end

    def errors 
        @errors ||= {}
    end

    def valid?
        self.class._validators.keys.each do |attr|
            send("valid_#{attr}")
        end
        errors.empty?
    end
end

module ModelClass
    def self.included(base)
        base.extend(ClassMethods)
    end

    module ClassMethods
        def has_many(attribute, options=nil)
            class_name = get_klass attribute
            klass = validate_klass class_name
            @associations ||= []
            @associations << attribute
            
            define_method("#{attribute}") do
                raise TypeError, "Association not defined with existing class" unless self.class.associations.include?(attribute)
                instance_variable_get("@#{attribute}") ||
                                instance_variable_set("@#{attribute}", [])
            end
            
            #setter function
            define_method("#{attribute}<<") do |attr_name|
                raise TypeError, "Association not defined with existing class" unless attr_name.is_a? (klass) || self.class.associations.include?(attribute)
                send(attribute) << value
            end
        end
        
        def associations
            @associations ||= []
        end
        
        def get_klass(attribute)
            attribute.to_s.singularize.capitalize
        end

        def validate_klass klass
            if Object.const_defined?(klass)
                klass = Object.const_get(klass)
            else
                raise NameError, "Association Class #{klass} not defined"
            end

            klass
        end
    end
end

class ActiveRecord
    include SimpleValidation
    include ModelClass
end

class Post < ActiveRecord
    attr_accessor :description, :title

    def title
        @title ||= Faker::Lorem.words(number: rand(2..10)).join(" ")
    end

    def description
        @description ||= Faker::Lorem.paragraphs
    end
end

class Comment < ActiveRecord
end

class User < ActiveRecord
    
    attr_accessor :email, :name
    validates :name, presence: true
    validates :email, presence: true
    has_many :posts
end

@user = User.new
@user.email = "raushan.raman@mail.com"
10.times do
    @user.posts << Post.new
end

pp @user.email = Faker::Internet.email
pp @user.name = Faker::Name.name
pp @user.posts.map {|p| [p.title, p.description.join(" ")]}
puts "------------------------------"
pp @user.comments