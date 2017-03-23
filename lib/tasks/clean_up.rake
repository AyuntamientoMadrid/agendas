namespace :clean do

  task :remove_duplicate_position_by_holders => :environment do
    duplicate_positions = Position.select('COUNT(title) as total, title, holder_id').
      group(:area_id, :title, :holder_id).
      having('COUNT(title) > 1').
      order(:title, :holder_id).map{|p| {p.holder_id => p.title} }

    puts '**********'
    duplicate_positions.each do |duplicate_position|
      duplicate_position.each do |holder_id, title|
        first = true
        puts "holder_id=#{holder_id}, Value=#{title}"

        positions = Position.where(holder_id: holder_id, title: title)
        positions.each do |position|

          if first
            @position_unique = position.id
          end

          puts "Change event with position_id #{position.id} to position #{@position_unique}, because #{title} duplicated"
          events = Event.where(position_id: position.id)
          events.each do |event|
            event.position_id = @position_unique
            event.save!
          end

          puts "Change participants with position_id #{position.id} to position #{@position_unique}, because #{title} duplicated"
          participants = Participant.where(position_id: position.id)
          participants.each do |participant|
            participant.position_id = @position_unique
            participant.save!
          end

          puts "Delete position #{position.id}-#{title} at holder #{holder_id}"
          unless first
            position.destroy
          end
          first = false
        end
      end
    end
    #
    puts '**********'
  end

  task :test_several_current_positions => :environment do
    count = 0
    holders = Holder.all.order(:last_name)
    uweb_api = UwebApi.new

    holders.each do |holder|
      positions = Position.current.where(holder_id: holder.id)

      if positions.count > 1
        count += 1
        puts "Several **current** positions at holder #{holder.id}"
        data = uweb_api.get_user(holder.user_key)
        puts '**Baja lógica**' if data['BAJA_LOGICA'] == '1'
        puts 'Activo' if data['BAJA_LOGICA'] == '0'
        puts data.inspect
        puts ''
      end
    end
    puts "Total=#{count} holders without several current positions"

  end

  task :test_several_positions => :environment do
    count = 0
    holders = Holder.all.order(:last_name)

    holders.each do |holder|
      positions = Position.where(holder_id: holder.id)

      if positions.count > 2
        count += 1
        puts "#{positions.count} positions #{holder.id}"
      end
    end
    puts "Total=#{count} holders without several positions"
  end

  task :one_import, [:clave_ind] => :environment do |t, arg|
    p "Test import holder | clave_ind=#{arg[:clave_ind]}"
    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    begin
      data = uweb_api.get_user(arg[:clave_ind])

    rescue => e
      puts "Holder with uweb_key #{@uweb_api.get_user(mc['CLAVE_IND'])} exception"
      puts e.message            # Test de excepción
      puts e.backtrace.inspect
    end

    if e.nil?

      holder = Holder.create_from_uweb(data)

      unless data['COD_UNIDAD'].nil?
        units = directory_api.get_units(data['COD_UNIDAD'])

        unless units.nil?
          unidad = units['UNIDAD_ORGANIZATIVA']
          if unidad.kind_of?(Array)
            unidad_pos = unidad.index{|u|u['COD_ORGANICO'] == data['COD_UNIDAD']}
            unit = unidad[unidad_pos]['ID_UNIDAD']
            directory_api.create_tree(unidad[unidad_pos])
          else
            unit = unidad['ID_UNIDAD']
            directory_api.create_tree(unidad)
          end
        end
      end

      # Comprobamos si el cargo y el area coinciden
      area = Area.find_by(internal_id: unit)

      holder.positions.each do |position|
        begin
          position.finalize.save! if position.to.nil?
        rescue => e
          p 'Error at finalize position'
        end
      end

      #Comprobamos si existe cargo, hay algun caso eliminado por GI sin cargo
      if data['CARGO'].present?
        begin
          position = Position.find_or_create_by(title: data['CARGO'], area: area, holder: holder)
          position.holder_id = holder.id
          position.to = nil unless data['BAJA_LOGICA'] == '1'
          position.from = Time.now if position.from.nil?

          position.save!
          holder.positions << position
        rescue => e
          p 'Error at save position'
        end
      end

      if holder.valid?
        begin
          holder.save!
        rescue => e
          p 'Error at save holder'
        end
        puts holder.id
      else
        p 'Something unexpected'
        p holder
        p holder.errors
      end
    end
  end

  task :test_events => :environment do
    events = Event.all

    puts 'Init'
    events.each do |event|
      positions = event.positions

      positions.each do |position|
        puts "Error at holder #{position.holder_id}" unless Holder.find(position.holder_id).valid?
      end
      participants = event.participants
      participants .each do |participant|
        position_participant = Position.find(participant.position_id)
        puts "Error at holder #{position_participant.holder_id}" unless Holder.find(position_participant.holder_id).valid?
      end

    end
    puts 'End'
  end


  task :holder_without_positions => :environment do
    holders = Holder.all.order(:last_name)
    count = 0

    holders.each do |holder|
      unless Position.exists?(holder_id: holder.id)
        count += 1
        puts "Holder #{holder.id} without positions"
      end
    end

    puts "Total=#{count} holders without positions"

  end

  task :holder_without_current_positions => :environment do
    count = 0
    holders = Holder.all.order(:last_name)

    holders.each do |holder|
      unless Position.current.exists?(holder_id: holder.id)
        count += 1
        puts "Holder #{holder.id} without current positions"
      end
    end
    puts "Total=#{count} holders without current positions"
  end

  task :change_position_at_event, [:pos_old, :pos_new, :year, :month, :day] => :environment do |t, arg|
    count = 0
    #events = Event.where("position_id= ? and created_at > ?", arg[:pos_old], DateTime.new(arg[:year],arg[:month],arg[:day],0,0,0))
    events = Event.where("position_id= ? and created_at > ?", arg[:pos_old], DateTime.new(2016,3,31,0,0,0))
    puts "Change position=#{arg[:pos_old]}, with new position=#{arg[:pos_new]}"
    events.each do |event|
      count += 1
      event.position_id = arg[:pos_new]
      event.save!
      puts event.inspect
    end
    puts "Total=#{count} events with position #{arg[:pos_old]}, save new position #{arg[:pos_new]}"

  end


  task :show_area_by_position,[:clave_ind] => :environment do |t, arg|
    p "Test import holder | clave_ind=#{arg[:clave_ind]}"
    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    begin
      data = uweb_api.get_user(arg[:clave_ind])

    rescue => e
      puts "Holder with uweb_key #{@uweb_api.get_user(mc['CLAVE_IND'])} exception"
      puts e.message            # Test de excepción
      puts e.backtrace.inspect
    end

    if e.nil?

      holder = Holder.create_from_uweb(data)

      unless data['COD_UNIDAD'].nil?
        units = directory_api.get_units(data['COD_UNIDAD'])

        unless units.nil?
          unidad = units['UNIDAD_ORGANIZATIVA']
          if unidad.kind_of?(Array)
            unidad_pos = unidad.index{|u|u['COD_ORGANICO'] == data['COD_UNIDAD']}
            unit = unidad[unidad_pos]['ID_UNIDAD']
          else
            unit = unidad['ID_UNIDAD']
          end
          directory_api.create_tree(unit)
        end
      end

      # Comprobamos si el cargo y el area coinciden
      area = Area.find_by(internal_id: unit)
      puts area.inspect
      puts area.title
    end

  end


end
