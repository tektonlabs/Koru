question = Question.create text: "Del 1 al 7, califica la limpieza de las areas", entity: Entity.find_by(name: "Limpieza")
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question

  sub_question = Question.create text: "Baño", entity: Entity.find_by(name: "Baño"), min_text: "Limpio", max_text: "Muy sucio", parent_id: Question.find_by(text: "Del 1 al 7, califica la limpieza de las areas").id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "1")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "2")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "3")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "4")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "5")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "6")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "7")

  sub_question = Question.create text: "Carpas", entity: Entity.find_by(name: "Carpas"), min_text: "Limpio", max_text: "Muy sucio", parent_id: Question.find_by(text: "Del 1 al 7, califica la limpieza de las areas").id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "1")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "2")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "3")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "4")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "5")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "6")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "7")

  sub_question = Question.create text: "Área común", entity: Entity.find_by(name: "Área común"), min_text: "Limpio", max_text: "Muy sucio", parent_id: Question.find_by(text: "Del 1 al 7, califica la limpieza de las areas").id
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "1")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "2")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "3")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "4")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "5")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "6")
    QuestionAnswer.create question: sub_question, answer: Answer.find_by(name: "7")

question = Question.create text: "¿Qué productos necesitas con urgencia?", entity: Entity.find_by(name: "Limpieza")
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Bolsas de basura")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Cloro")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Paños")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Tachos")

question = Question.create text: "Observaciones", entity: Entity.find_by(name: "Limpieza"), question_type: :input_value
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question

question = Question.create text: "¿Tienes luz eléctrica?", entity: Entity.find_by(name: "Luz")
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Si")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "No")

question = Question.create text: "¿Tienes alguno de estos?", entity: Entity.find_by(name: "Luz")
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question

  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Velas")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Lamparines")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Generador eléctrico")
  QuestionAnswer.create question: question, answer: Answer.find_by(name: "Otros")

question = Question.create text: "Observaciones", entity: Entity.find_by(name: "Luz"), question_type: :input_value
RefugeQuestion.create refuge: Refuge.find_by(name: "Piura"), question: question
