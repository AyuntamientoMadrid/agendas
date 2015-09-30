
require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :generator do

  desc "Llena"


  task :initialize => :environment do

    Faker::Config.locale = 'en-US'

    Rake::Task['db:reset'].invoke

    Rake::Task['generator:areas_main'].invoke("5")

    Rake::Task['generator:areas_children'].invoke("7")

    Rake::Task['generator:users'].invoke("30")


    Rake::Task['generator:holders'].invoke("30")



    Rake::Task['generator:positions'].invoke

    Rake::Task['generator:events'].invoke("50")

    Rake::Task['generator:attendees'].invoke("8")


    ##Rake::Task['generator:attachments'].invoke



    p ""
    p ""
    p "Finished OK!"
  end


  task :areas_main, [:quantity] => :environment do |t, args|

    args[:quantity].to_i.times do

      a = Area.create(:title => "Department of " + Faker::Commerce.department(4, false), :parent_id => 0, :active => 1)
      p a
    end

  end

  task :areas_children, [:quantity] => :environment do |t, args|

    args[:quantity].to_i.times do

      main_area = Area.main_areas.shuffle[0]



      children = Area.create(:title => "Department of " + Faker::Commerce.department(4, false), :parent_id => main_area.id, :active => 1)
      p children
      args[:quantity].to_i.times do
        a = Area.create(:title => "Department of " + Faker::Commerce.department(4, false), :parent_id => children.id, :active => 1)
        p a
      end

    end

  end

  task :users, [:quantity] => :environment do |t, args|

    args[:quantity].to_i.times do

      u = User.create(:password => Faker::Internet.password, :email => Faker::Internet.email, :first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name, :active => 1 )

      if rand(0..1)==1
        u.admin!
      else
        u.user!
      end

      p u

    end

  end


  task :holders, [:quantity] => :environment do |t, args|

    args[:quantity].to_i.times do

      h = Holder.create(:first_name => Faker::Name.first_name, :last_name => Faker::Name.last_name)
      h.users << User.user.shuffle[0]
      p h
    end

  end




  task :events, [:quantity] => :environment do |t, args|

    args[:quantity].to_i.times do

      holder = Holder.all.shuffle[0]
      position = Position.current.where(:holder => holder)[0]

      e = Event.create(:title => Faker::Lorem.sentence, :description => Faker::Lorem.paragraph(6, false, 2), :scheduled => rand(0..1)==1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning), :user => Holder.last.users[0], :position => position)
      p e

      rand(0..5).times do

        e.positions << Position.current.where("id <> ?", position.id).shuffle[0]

      end



    end

  end


  task :attendees, [:quantity] => :environment do |t, args|

    Event.all.each do |e|
      rand(4..args[:quantity].to_i).times do

        a = Attendee.create(:event => e,:name => Faker::Name.name, :position => Faker::Name.title, :company => Faker::Company.name )
        p a

      end
    end


  end


  task :attachments, [:quantity] => :environment do |t, args|

    Event.all.each do |e|
      rand(0..2).times do

        a = Attachment.create(:title => "pepe", :file => File.open("/tmp/1.pdf"))
        p a

      end
    end


  end

  task :positions => :environment do |t, args|


      Holder.all.each do |h|
        #actual
        p = Position.create(:title => Faker::Name.title, :from => Faker::Time.between(5.months.ago, Time.now - 1.months, :all), :to => nil, :area_id => Area.all.shuffle[0].id, :holder_id => h.id)
        #anteriores
        rand(1..4).times do
          p = Position.create(:title => Faker::Name.title, :from => Faker::Time.between(1.year.ago, Time.now - 6.months, :all), :to => Faker::Time.between(6.months.ago, Time.now - 1.months, :all), :area_id => Area.all.shuffle[0].id, :holder_id => h.id)
          p p
        end

      end


  end


end
