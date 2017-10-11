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

# Alimentos y agua bebible

question = Question.create text: "¿Hubo suficiente agua para beber y cocinar para todo el refugio?", entity: Entity.find_by(name: "Alimentos y agua bebible")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Faltaron raciones de comida?", entity: Entity.find_by(name: "Alimentos y agua bebible")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Algún comentario extra sobre la alimentación y el agua bebible en el refugio?", entity: Entity.find_by(name: "Alimentos y agua bebible"), question_type: :input_value


# Salud

question = Question.create text: "¿Se considera que algunas de estas personas deba ser evacuada por motivos de salud?", entity: Entity.find_by(name: "Salud"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Mujeres embarazadas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Niños menores a 3 años")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Niños menores a 12 años")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Adultos mayores")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Por qué?", entity: Entity.find_by(name: "Salud"), question_type: :input_value

question = Question.create text: "Hubo presencia de:", entity: Entity.find_by(name: "Salud")

    sub_question = Question.create text: "Médicos", entity: Entity.find_by(name: "Médicos"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

    sub_question = Question.create text: "Enfermeras", entity: Entity.find_by(name: "Enfermeras"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

    sub_question = Question.create text: "Técnicos en salud", entity: Entity.find_by(name: "Técnicos en salud"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

    sub_question = Question.create text: "Voluntarios de salud", entity: Entity.find_by(name: "Voluntarios en salud"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

question = Question.create text: "¿Se necesita alguna de estas medicinas? (marca todas las que sean necesarias)", entity: Entity.find_by(name: "Salud"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para las heridas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la diarrea")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la fiebre")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la tos y resfrío")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la infección (antibióticos)")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Vacunas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")


# Higiene

question = Question.create text: "¿Se necesita alguno de estos artículos? (marca todas las que sean necesarias)", entity: Entity.find_by(name: "Higiene personal"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Papel higiénico")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Pañales niños")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Pañales ancianos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Repelente")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Toallas higiénicas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Jabón")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Shampoo")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Cepillo de dientes")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Pasta dental")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")


# Limpieza

question = Question.create text: "¿Están limpios los siguientes lugares?", entity: Entity.find_by(name: "Limpieza")

  sub_question = Question.create text: "Baños", entity: Entity.find_by(name: "Baños"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Sí")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No"), class_type: :negative

  sub_question = Question.create text: "Carpas", entity: Entity.find_by(name: "Carpas"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Sí")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No"), class_type: :negative

  sub_question = Question.create text: "Áreas comunes", entity: Entity.find_by(name: "Áreas comunes"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Sí")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No"), class_type: :negative

  sub_question = Question.create text: "Cocina", entity: Entity.find_by(name: "Cocinas"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Sí")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Qué productos de limpieza se necesita con urgencia? (marca todos los que falten)", entity: Entity.find_by(name: "Limpieza"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Bolsas de basura")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Cloro")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Paños")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Tachos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Escobillas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Recogedores")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Detergente")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Escobas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Bateas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Trapeadores")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Desinfectantes")

question = Question.create text: "¿Algún comentario extra sobre la limpieza del refugio?", entity: Entity.find_by(name: "Limpieza"), question_type: :input_value


#Electricidad

question = Question.create text: "¿Tienen electricidad?", entity: Entity.find_by(name: "Electricidad")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Se están usando alguno de estos mecanismos de iluminación o alguna fuente de energía? (marca todos los que se estén usando)", entity: Entity.find_by(name: "Electricidad"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Linternas"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Lamparines"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Velas"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Generador eléctrico"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros"), class_type: :negative

question = Question.create text: "¿Algún comentario extra sobre la electricidad del refugio?", entity: Entity.find_by(name: "Electricidad"), question_type: :input_value


# Agua

question = Question.create text: "¿Tienen agua para los baños, duchas y lavanderías?", entity: Entity.find_by(name: "Agua")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Queda poca"), class_type: :middle
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Tienen como almacenar el agua?", entity: Entity.find_by(name: "Agua")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Está yendo el camión cisterna a dejar agua?", entity: Entity.find_by(name: "Agua")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Algún comentario extra sobre el agua del refugio?", entity: Entity.find_by(name: "Agua"), question_type: :input_value


# Gestión de residuos sólidos

question = Question.create text: "¿Cuentan con basureros y puntos de acopio de basura?", entity: Entity.find_by(name: "Gestión de residuos sólidos")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Se está recogiendo la basura que el albergue acumula?", entity: Entity.find_by(name: "Gestión de residuos sólidos")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Sí")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No"), class_type: :negative

question = Question.create text: "¿Quién es el encargado del recojo de basura?", entity: Entity.find_by(name: "Gestión de residuos sólidos")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Municipalidad")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No hay nadie encargado del recojo de basura"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Algún comentario extra sobre la gestión de residuos sólidos del refugio?", entity: Entity.find_by(name: "Gestión de residuos sólidos"), question_type: :input_value


# Seguridad

question = Question.create text: "¿Se han reportado algunas de las siguientes incidencias?", entity: Entity.find_by(name: "Seguridad"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Robos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Agresiones verbales")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Agresiones físicas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Tocamientos indebidos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Violaciones")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Cómo se resolvió el incidente?", entity: Entity.find_by(name: "Seguridad")

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No se resolvió"), class_type: :negative
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Se expulsó al agresor")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "La policía intervino")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "Hubo presencia de:", entity: Entity.find_by(name: "Seguridad")

  sub_question = Question.create text: "Policías", entity: Entity.find_by(name: "Policías"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

  sub_question = Question.create text: "Serenazgos", entity: Entity.find_by(name: "Serenazgos"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

  sub_question = Question.create text: "Fuerzas armadas", entity: Entity.find_by(name: "Fuerzas armadas"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

  sub_question = Question.create text: "Comité de seguridad", entity: Entity.find_by(name: "Comité de seguridad"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca"), class_type: :middle
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo"), class_type: :negative

question = Question.create text: "¿Se han observado alguna de las siguientes situaciones de riesgo?", entity: Entity.find_by(name: "Seguridad"), question_type: :multiple_choice

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Malversación de donaciones/recursos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Velas dentro de carpas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Venta y/o consumo de drogas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Pandillaje")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Prostitución")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Ataques de animales")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Algún comentario extra sobre la seguridad en el refugio?", entity: Entity.find_by(name: "Seguridad"), question_type: :input_value