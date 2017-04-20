# Alimentos y agua bebible

question = Question.create text: "¿Hubo suficiente agua para beber y cocinar para todo el refugio?", entity: Entity.find_by(name: "Alimentos y agua bebible")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Faltaron raciones de comida?", entity: Entity.find_by(name: "Alimentos y agua bebible")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Algún comentario extra sobre la alimentación y el agua bebible en el refugio?", entity: Entity.find_by(name: "Alimentos y agua bebible"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end


# Salud

question = Question.create text: "¿Se considera que alguna de estas personas deba ser evacuada por motivos de salud?", entity: Entity.find_by(name: "Salud"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Mujer embarazada")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Niño menor a 3 años")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Niño menor a 12 años")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Adulto mayor")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Adulto mayor")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Por qué?", entity: Entity.find_by(name: "Salud"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

question = Question.create text: "Hubo presencia de:", entity: Entity.find_by(name: "Salud")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

    sub_question = Question.create text: "Médico", entity: Entity.find_by(name: "Médico"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

    sub_question = Question.create text: "Enfermeras", entity: Entity.find_by(name: "Enfermeras"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

    sub_question = Question.create text: "Técnicos en salud", entity: Entity.find_by(name: "Técnicos en salud"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

    sub_question = Question.create text: "Voluntarios de salud", entity: Entity.find_by(name: "Voluntarios de salud"), parent_id: question.id
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
      QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

question = Question.create text: "¿Se necesita alguna de estas medicinas? (marca todas las que sean necesarias)", entity: Entity.find_by(name: "Salud"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para las heridas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la diarrea")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la fiebre")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la tos y resfrío")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Para la infección (antibióticos)")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Vacunas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")


# Higiene

question = Question.create text: "¿Se necesita alguno de estos artículos? (marca todas las que sean necesarias)", entity: Entity.find_by(name: "Higiene personal"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

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
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  sub_question = Question.create text: "Baño", entity: Entity.find_by(name: "Baño"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

  sub_question = Question.create text: "Carpas", entity: Entity.find_by(name: "Carpas"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

  sub_question = Question.create text: "Áreas comunes", entity: Entity.find_by(name: "Áreas comunes"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

  sub_question = Question.create text: "Cocina", entity: Entity.find_by(name: "Cocina"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Qué productos de limpieza se necesita con urgencia? (marca todos los que falten)", entity: Entity.find_by(name: "Limpieza"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Bolsas de basura")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Cloro")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Paños")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Tachos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Escobillas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Recogedores")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Detergente")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Escoba")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Bateas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Trapeador")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Desinfectante")

question = Question.create text: "¿Algún comentario extra sobre la limpieza del refugio?", entity: Entity.find_by(name: "Limpieza"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end


#Electricidad

question = Question.create text: "¿Tienen electricidad?", entity: Entity.find_by(name: "Electricidad")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Se están usando alguno de estos mecanismos de iluminación o alguna fuente de energía? (marca todos los que se estén usando)", entity: Entity.find_by(name: "Limpieza"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Linternas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Lamparines")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Velas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Generador eléctrico")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Algún comentario extra sobre la electricidad del refugio?", entity: Entity.find_by(name: "Limpieza"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end


# Agua

question = Question.create text: "¿Tienen agua para los baños, duchas y lavandería?", entity: Entity.find_by(name: "Agua")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Queda poca")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Tienen como almacenar el agua?", entity: Entity.find_by(name: "Agua")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Está yendo el camión cisterna a dejar agua?", entity: Entity.find_by(name: "Agua")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Algún comentario extra sobre el agua del refugio?", entity: Entity.find_by(name: "Agua"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end


# Gestión de residuos sólidos

question = Question.create text: "Sobre el recojo de la basura de todo el albergue", entity: Entity.find_by(name: "Gestión de residuos sólidos")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  sub_question = Question.create text: "¿Cuentan con basureros y puntos de acopio de basura?", entity: Entity.find_by(name: "Basureros y puntos de acopio de basura"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

  sub_question = Question.create text: "¿Se está recogiendo la basura que el albergue acumula?", entity: Entity.find_by(name: "Recogo de basura"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Si")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No")

  sub_question = Question.create text: "¿Quién es el encargado del recojo de basura?", entity: Entity.find_by(name: "Gestión de residuos sólidos"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Municipalidad")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hay nadie encargado del recojo de basura")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Otros")

  sub_question = Question.create text: "¿Algún comentario extra sobre la gestión de residuos sólidos del refugio?", entity: Entity.find_by(name: "Gestión de residuos sólidos"), question_type: :input_value


# Seguridad

question = Question.create text: "¿Se han reportado algunas de las siguientes incidencias?", entity: Entity.find_by(name: "Seguridad"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Robos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Agresiones verbales")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Agresiones físicas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Tocamientos indebidos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Violaciones")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No se han reportado incidencias")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Cómo se resolvió el incidente?", entity: Entity.find_by(name: "Seguridad"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No se resolvió")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Se expulsó al agresor")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "La policía intervino")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "Hubo presencia de:", entity: Entity.find_by(name: "Salud")
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  sub_question = Question.create text: "Policías", entity: Entity.find_by(name: "Policías"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

  sub_question = Question.create text: "Serenazgos", entity: Entity.find_by(name: "Serenazgos"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

  sub_question = Question.create text: "Fuerzas armadas", entity: Entity.find_by(name: "Fuerzas armadas"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

  sub_question = Question.create text: "Comité de seguridad", entity: Entity.find_by(name: "Comité de seguridad"), parent_id: question.id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Suficiente")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "Poca")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "No hubo")

question = Question.create text: "¿Se han reportado algunas de las siguientes situaciones de riesgo?", entity: Entity.find_by(name: "Seguridad"), question_type: :multiple_choice
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Malversación de donaciones/recursos")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Velas dentro de carpas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Venta y/o consumo de drogas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Pandillaje")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Prostitución")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Ataques de animales")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No se han detectado")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "¿Algún comentario extra sobre la seguridad en el refugio?", entity: Entity.find_by(name: "Seguridad"), question_type: :input_value
  Refuge.all.each do |refuge|
    RefugeQuestion.create refuge: refuge, question: question
  end