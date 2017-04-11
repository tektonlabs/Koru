refuge = Refuge.create name: "Piura"
  RefugeEntity.create refuge: refuge, entity: Entity.find_by(name: "Limpieza")
  RefugeEntity.create refuge: refuge, entity: Entity.find_by(name: "Luz")