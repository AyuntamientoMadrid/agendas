# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Interests
interests = ['Actividad económica y empresarial',
             'Actividad normativa y de regulación',
             'Administración de personal y recursos humanos',
             'Administración electrónica',
             'Administración económica, financiera y tributaria de la Ciudad',
             'Atención a la ciudadanía',
             'Comercio',
             'Consumo',
             'Cultura (bibliotecas, archivos, museos, patrimonio histórico artístico, etc.)',
             'Deportes',
             'Desarrollo tecnológico',
             'Educación y Juventud',
             'Emergencias y seguridad',
             'Empleo',
             'Medio Ambiente',
             'Medios de comunicación',
             'Movilidad, transporte y aparcamientos',
             'Salud',
             'Servicios sociales',
             'Transparencia y participación ciudadana',
             'Turismo',
             'Urbanismo',
             'Vivienda']

interests.each do |name|
  Interest.find_or_create_by(name: name)
end
puts "Interests created ✅"

# Categories
names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones', 'Fundaciones',
         'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
         'ONGs y plataformas sin personalidad jurídica',
         'Universidades y centros de investigación',
         'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
         'Iglesia y otras confesiones', 'Otro tipo de sujetos']

names.each do |name|
  Category.find_or_create_by(name: name, display: true)
end
puts "Categories created ✅"

#Faq
Question.create(title: "¿Qué es un registro de lobbies?",
answer: "Es el espacio público y gratuito en el que debe inscribirse toda persona física y jurídica, o entidades sin personalidad jurídica que quieran actuar directamente o en representación de un tercero si quieren hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.",
position: 1)

Question.create(title: "¿Por qué hacer un Registro de Lobbies en el Ayuntamiento de Madrid?",
answer: "Los principales objetivos de hacer un registro de lobbies son que el proceso de toma de decisiones en el Ayuntamiento sea más transparente y conocer qué intereses representan las personas que se reúnen con los representantes públicos. La decisión de crearlo se tomó en la Ordenanza de Transparencia de la Ciudad de Madrid, que obliga a registrarse a todas las personas que quieran reunirse con concejales, directivos o personal eventual municipal con el fin de ejercer influencia sobre los asuntos públicos de relevancia.",
position: 2)

Question.create(title: "¿Dónde se puede inscribir alguien en el Registro de Lobbies?",
answer: "En el espacio de inscripción en el Portal de Transparencia. ***Incluir link a la inscripción.***",
position: 3)

Question.create(title: "¿Se puede registrar presencialmente en el Registro de Lobbies?",
answer: "La declaración responsable solo se podrá presentar electrónicamente.",
position: 4)

Question.create(title: "¿Hace falta identificarse electrónicamente para registrarse?",
answer: "Sí, es necesario. **** ncluir más detalle sobre por qué es necesario, obligación legal etc... +mesegueryj@madrid.es puedes meter algo?****",
position: 5)

Question.create(title: "¿Cómo se puede solicitar la baja en el registro?",
answer: "Para solicitar la baja, deberá presentarse una declaración responsable.",
position: 6)

Question.create(title: "¿Qué información se debe dar para inscribirse en el Registro de Lobbies?",
answer: "La información que debe incluirse a la hora de inscribirse en el Registro de Lobbies son los datos mínimos de quién ejerce la actividad de lobby y las personas o entidades representadas. En concreto se debe indicar: Nombre la persona que se inscribe, nombre del representante legal, Nombre y datos de la persona de contacto.*****Completar con los datos del formulario. +crespodhe@madrid.es puedes meter lo que falta?*****",
position: 7)

Question.create(title: "¿Cuánto se tarda en inscribirse en el Registro de Lobbies de la Ciudad de Madrid?",
answer: "La inscripción puede formalizarse en un tiempo muy breve siempre que se faciliten todos los datos necesarios. El procedimiento se limita a completar un formulario y está pensado para que sea sencillo y ágil.",
position: 8)

Question.create(title: "¿La inscripción debe ser confirmada o se confirma al acabar de registrar los datos?",
answer: "La inscripción se considera completada en el momento en que se envía correctamente la declaración responsable. La información que se ha proporcionada aparecerá automáticamente publicada en el Registro de Lobbies, no siendo necesaria ninguna confirmación por parte del Ayuntamiento de Madrid.",
position: 9)

Question.create(title: "¿Qué ventajas tiene registrarse en el Registro de Lobbies?",
answer: "El lobby se puede incluir en listas de distribución de contenidos relacionados con las áreas de actividad o interés que haya manifestado, con el fin de facilitar su participación. También podrá solicitar reuniones y encuentros a través del registro con aquellos/as responsables municipales que mantengan agenda institucional. La información relativa a los procedimientos en los que haya intervenido podrá incluir una mención expresa de su participación.",
position: 10)

Question.create(title: "¿Solo se publicará la información sobre reuniones que se celebren en dependencias oficiales del Ayuntamiento de Madrid?",
answer: "No, necesariamente. La actividad de lobby puede llevarse a cabo con independencia del lugar en el que se realice, ya se trate de dependencias municipales o no.",
position: 11)

Question.create(title: "¿La información sobre las reuniones que se mantienen con el Ayuntamiento de Madrid también es pública?",
answer: "Sí, ya lo es desde 2015, tras la aprobación de los acuerdos de la Junta de Gobierno sobre la publicación de las agendas institucionales. En mayo de 2016 se puso en marcha la aplicación actual para publicar esta información.",
position: 12)

Question.create(title: "¿Cómo se puede saber quién ha llevado a cabo actividad de lobby en el Ayuntamiento de Madrid?",
answer: "Existirá la posibilidad de consultar la agenda institucional para conocer qué reuniones se han mantenido con objeto de hacer lobby. También será posible conocer esta información en el espacio del portal de transparencia dedicado al Registro de Lobbies.",
position: 13)

Question.create(title: "¿Quién tiene que registrarse en el Registro de Lobbies de la Ciudad de Madrid?",
answer: "Todas las personas físicas y jurídicas o entidades sin personalidad jurídica que quieran actuar directamente o en representación de un tercero o de un grupo organizado de carácter privado o no gubernamental. Tendrán que registrarse si actúan con el objetivo de hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos. Las entidades inscritas en el Registro de Entidades Ciudadanas del Ayuntamiento de Madrid no tienen obligación de inscribirse en el Registro de Lobbies.",
position: 14)

Question.create(title: "¿Las asociaciones de vecinos y las entidades sin ánimo de lucro deben registrarse?",
answer: "Las entidades inscritas en el Registro de Entidades Ciudadanas del Ayuntamiento de Madrid no tienen obligación de inscribirse en el Registro de Lobbies, pero pueden hacerlo voluntariamente para beneficiarse de las ventajas que tiene inscribirse.
En cualquier caso, las entidades que no figuren en el Registro de Entidades Ciudadanas del Ayuntamiento deben registrarse.",
position: 15)

Question.create(title: "¿Debo registrarme para reunirme con cualquier persona o un concejal/a, un directivo/a o personal eventual del Ayuntamiento de Madrid?",
answer: "Es obligatorio registrarse únicamente si el objetivo de la reunión es hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.",
position: 16)

Question.create(title: "¿Si me llaman desde el Ayuntamiento para una reunión debo registrarme?",
answer: "La obligación de registrarse surge si el objetivo de la reunión es hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos. En este caso será el ayuntamiento el que te indique que te tienes que inscribir en el Registro de Lobbies y cómo.",
position: 17)

Question.create(title: "¿Si me encuentro con un trabajador/a del Ayuntamiento por la calle debo estar registrado para hablar con ellos/as?",
answer: "No, solo es obligatorio registrarse cuando el encuentro se mantenga con un concejal/a, directivo/a o personal eventual. En caso de reunirse con alguna de estas personas, la conversación tendría que tener por objeto hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos. Además, el interlocutor/a debería formar parte de una entidad que cumpla los requisitos para inscribirse previamente en este registro. Será el concejal/a, directivo/a o trabajador/a eventual quien valore, en función del contenido de dicha conversación, la necesidad de inscribirse y debería advertírselo a la persona con la que converse",
position: 18)

Question.create(title: "¿Debo estar registrado en el Registro de Lobbies antes de mantener una reunión con el Ayuntamiento de Madrid?",
answer: "Los concejales, directivos y personal eventual, antes de celebrar cualquier reunión, encuentro o comunicación con personas o entidades que vayan a ejercer lobby, deben verificar previamente que están inscritas en el registro. En caso de comprobar que no lo están, no podrá llevarse a cabo la reunión, encuentro o comunicación mientras no se registren.",
position: 19)

Question.create(title: "¿Qué sucede si durante una reunión, quiero plantear alguna cuestión que me obligaría a estar inscrito en el Registro de Lobbies y no lo estoy?",
answer: "Si en el curso de una reunión, encuentro o comunicación se apreciara que la persona o entidad lleva a cabo alguna actividad que exija el previo registro, habrá que advertir expresamente de esta circunstancia y finalizar en ese mismo momento el encuentro.",
position: 20)

Question.create(title: "¿Puede alguien que vaya a ejercer lobby representar a varias personas o entidades? ¿Cómo se refleja esto en el Registro de Lobbies de la Ciudad de Madrid?",
answer: "Sí. En el Registro de Lobbies se puede consultar qué personas pueden mantener reuniones por cuenta de cada persona o entidad inscrita.",
position: 22)

Question.create(title: "¿La inscripción supone alguna obligación?",
answer: "La inscripción implica aceptar el código de conducta y todas las obligaciones que aparecen en la Ordenanza de Transparencia de la Ciudad de Madrid. Afecta a todos los sujetos que ejerzan la actividad de lobby y a las entidades inscritas en el Registro de Entidades Ciudadanas que lleven a cabo actividad de lobby La inscripción supone, asimismo, el compromiso de no hacer regalos no permitidos según lo dispuesto en el Acuerdo de 5 de noviembre de 2015 de la Junta de Gobierno de la Ciudad de Madrid. Así, se establece el régimen de regalos que reciban el alcalde, los miembros de la Junta de Gobierno, los concejales con responsabilidades de gobierno, los concejales-presidentes de los distritos, los titulares de los órganos directivos y los empleados públicos del Ayuntamiento de Madrid y sus organismos autónomos.",
position: 22)

Question.create(title: "¿Qué es el código de conducta de los lobbistas?",
answer: "El código de conducta establece las obligaciones de aquellas personas que quieren influir sobre las decisiones públicas. Está recogido en el Artículo 37 de la Ordenanza de Transparencia y establece lo siguiente:Código de conducta 1. La inscripción en el Registro de Lobbies supone las siguientes obligaciones: a) Aceptar que la información proporcionada se haga pública. b) No obtener ni tratar de obtener la información o influir en la toma de decisiones de forma deshonesta. c) Proporcionar información actualizada y no engañosa en el momento de inscribirse en el Registro y de mantenerla actualizada, y garantizar que la que se suministre en cumplimiento de lo dispuesto en esta ordenanza es correcta y fidedigna. d) No incitar a los titulares de los órganos directivos a incumplir lo dispuesto en este capítulo.",
position: 23)

Question.create(title: "¿Existe algún control sobre aquellos que no cumplen con las obligaciones del registro?",
answer: "La Comisión de Seguimiento de la Ordenanza de Transparencia controlará que los concejales, directivos y el personal eventual no celebren reuniones ni encuentros con personas no inscritas en el Registro de Lobbies, cuando las reuniones tengan por objeto actividades sujetas a registro. Se articulará un buzón electrónico para que se puedan comunicar de manera anónima los incumplimientos de lo dispuesto en la regulación municipal sobre lobby. De estas comunicaciones se dará cuenta a la Comisión de Seguimiento.",
position: 24)

Question.create(title: "¿Existen sanciones para aquellas personas inscritas en el Registro de Lobbies que entreguen datos falsos o incumplan el código de conducta?",
answer: "La inexactitud, falsedad u omisión, de carácter esencial, de cualquier dato o información que se incorpore a la declaración responsable o el no presentar la documentación requerida para acreditar que se cumple lo declarado, determinará la baja en el registro, perder los incentivos y la posibilidad de mantener reuniones con concejales, directivos y el personal eventual.",
position: 25)

Question.create(title: "¿Existen sanciones para aquellos representantes públicos que mantengan reuniones con actividad de lobby con personas no inscritas?",
answer: "El sistema de sanciones discurre de la siguiente manera: Si la Comisión de Seguimiento de la Ordenanza de Transparencia entiende que puede existir algún tipo de incumplimiento, solicitará un informe a la persona obligada por la normativa de lobbies e implicada en dicho incumplimiento. A la vista de lo que se informe, la Comisión de Seguimiento puede: Realizar una recomendación para que ajuste su actuación a lo previsto en la Ordenanza (se publicará en el Boletín Oficial del Ayuntamiento). Apercibir a la persona en cuestión si se ha generado un daño leve. Proponer el cese de la persona que haya incumplido la Ordenanza a la Junta de Gobierno, si se ha producido un daño grave (esta medida no será aplicable a los concejales).",
position: 26)

Question.create(title: "¿Qué normas regulan el registro de Lobbies de la Ciudad de Madrid?",
answer: "La Ordenanza de Transparencia de la Ciudad de Madrid regula el Registro de Lobbies en su capítulo IV:",
position: 27)

Question.create(title: "¿Qué otras ciudades o instituciones cuentan con un registro de lobbies?",
answer: "Actualmente funcionan registros similares en la Comunidad Autónoma de Cataluña y en la Comisión Nacional de los Mercados y de la Competencia (en este caso, la inscripción es voluntaria). Algunas Comunidades Autónomas, como Castilla-La Mancha, lo incluyen en su normativa, pero aún no funciona.",
position: 28)

puts "Faq created ✅"
