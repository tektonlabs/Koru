refuge = Refuge.create name: "Cristo Viene", latitude: "-5.3252875", longitude: "-80.6641267", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Km 980'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Jesús de Nazareth", latitude: "-5.3251123", longitude: "-80.6644547", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Km 980'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Santa Rosa", latitude: "-5.3251123", longitude: "-80.6644547", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Km 980'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Túpac Amaru", latitude: "-5.3251123", longitude: "-80.6644547", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Km 980'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "San Martín", latitude: "-5.3251123", longitude: "-80.6644547", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Km 980'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Juan Pablo II - La Legua", latitude: "-5.2371187", longitude: "-80.6724573", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Sector Centro'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Villa San Jacinto Casa de retiro", latitude: "-5.2467128", longitude: "-80.6721022", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Villa San Jacinto'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Casa María", latitude: "-5.2007787", longitude: "-80.6327704", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Av. Circunvalación al costado de Migraciones'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Casa Comunal AA.HH. Fátima", latitude: "-5.1941916", longitude: "-80.6535585", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'AA.HH. Fátima'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Colegio San José", latitude: "-5.1806674", longitude: "-80.6534903", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Urbanización San José'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuge = Refuge.create name: "Colegio San Ignacio de Loyala", latitude: "-5.1869505", longitude: "-80.62148", country: Country.find_by(name: 'Peru'), city: 'Piura', address: 'Urbanización Miraflores'
  Entity.first_level.each do |entity|
    RefugeEntity.create refuge: refuge, entity: entity
  end

refuges = Refuge.all
refuges.each do |refuge|
  refuge.status = rand(0..2)
  refuge.save
end