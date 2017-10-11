# <!--

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

Entity.create name: "Alimentos y agua bebible"
Entity.create name: "Salud"
Entity.create name: "Higiene personal"
Entity.create name: "Limpieza"
Entity.create name: "Electricidad"
Entity.create name: "Agua"
Entity.create name: "Gestión de residuos sólidos"
Entity.create name: "Seguridad"

Entity.create name: "Baños", level: :second_level, parent: Entity.find_by(name: "Limpieza")
Entity.create name: "Carpas", level: :second_level, parent: Entity.find_by(name: "Limpieza")
Entity.create name: "Áreas comunes", level: :second_level, parent: Entity.find_by(name: "Limpieza")
Entity.create name: "Cocinas", level: :second_level, parent: Entity.find_by(name: "Limpieza")

Entity.create name: "Médicos", level: :second_level, parent: Entity.find_by(name: "Salud")
Entity.create name: "Enfermeras", level: :second_level, parent: Entity.find_by(name: "Salud")
Entity.create name: "Técnicos en salud", level: :second_level, parent: Entity.find_by(name: "Salud")
Entity.create name: "Voluntarios en salud", level: :second_level, parent: Entity.find_by(name: "Salud")

Entity.create name: "Policías", level: :second_level, parent: Entity.find_by(name: "Seguridad")
Entity.create name: "Serenazgos", level: :second_level, parent: Entity.find_by(name: "Seguridad")
Entity.create name: "Fuerzas armadas", level: :second_level, parent: Entity.find_by(name: "Seguridad")
Entity.create name: "Comité de seguridad", level: :second_level, parent: Entity.find_by(name: "Seguridad")
