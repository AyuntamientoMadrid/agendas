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
  Interest.create(name: name)
end
puts "Interests created ✅"

# Categories
names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones/Fundaciones',
         'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
         'ONGs y plataformas sin personalidad jurídica',
         'Universidades y centros de investigación',
         'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
         'Iglesia y otras confesiones', 'Otro tipo de sujetos']

names.each do |name|
  Category.find_or_create_by(name: name)
end
puts "Categories created ✅"

#Faq
Question.create(title: "¿Qué es un registro de lobbies?",
                answer: "Es el espacio público y gratuito en el que debe inscribirse toda persona física y jurídica, o entidades sin personalidad jurídica que quieran actuar directamente o en representación de un tercero si quieren hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.",
                position: 1)
Question.create(title: "¿Por qué hacer un Registro de Lobbies en el Ayuntamiento de Madrid?",
                answer: "Los principales objetivos de hacer un registro de lobbies son que el proceso de toma de decisiones en el Ayuntamiento sea más transparente y conocer qué intereses representan las personas que se reúnen con los representantes públicos. La decisión de crearlo se tomó en la Ordenanza de Transparencia de la Ciudad de Madrid, que obliga a registrarse a todas las personas que quieran reunirse con concejales, directivos o personal eventual municipal con el fin de ejercer influencia sobre los asuntos públicos de relevancia.",
                position: 2)
Question.create(title: "¿Quién tiene que registrarse en el Registro de Lobbies de la Ciudad de Madrid?",
                answer: "Todas las personas físicas y jurídicas o entidades sin personalidad jurídica que quieran actuar directamente o en representación de un tercero o de un grupo organizado de carácter privado o no gubernamental. Tendrán que registrarse si actúan con el objetivo de hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.
                Las entidades inscritas en el Registro de Entidades Ciudadanas del Ayuntamiento de Madrid no tienen obligación de inscribirse en el Registro de Lobbies.",
                position: 3)
Question.create(title: "¿Las asociaciones de vecinos y las entidades sin ánimo de lucro deben registrarse?",
                answer: "Las entidades inscritas en el Registro de Entidades Ciudadanas del Ayuntamiento de Madrid no tienen obligación de inscribirse en el Registro de Lobbies, pero pueden hacerlo voluntariamente para beneficiarse de las ventajas que tiene inscribirse.
                En cualquier caso, las entidades que no figuren en el Registro de Entidades Ciudadanas del Ayuntamiento deben registrarse.",
                position: 4)
Question.create(title: "¿Debo registrarme para reunirme con cualquier persona o un concejal/a, un directivo/a o personal eventual del Ayuntamiento de Madrid?",
                answer: "Es obligatorio registrarse únicamente si el objetivo de la reunión es hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.",
                position: 5)
Question.create(title: "¿Si me llaman desde el Ayuntamiento para una reunión debo registrarme?",
                answer: "La obligación de registrarse surge si el objetivo de la reunión es hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos.
                En este caso será el ayuntamiento el que te indique que te tienes que inscribir en el Registro de Lobbies y cómo.",
                position: 6)
Question.create(title: "¿Si me encuentro con un trabajador/a del Ayuntamiento por la calle debo estar registrado para hablar con ellos/as?",
                answer: "No, solo es obligatorio registrarse cuando el encuentro se mantenga con un concejal/a, directivo/a o personal eventual. En caso de reunirse con alguna de estas personas, la conversación tendría que tener por objeto hacer valer algún interés en la elaboración de la normativa municipal; en el diseño y desarrollo de las políticas públicas municipales y/o en la toma de decisiones del Ayuntamiento de Madrid y sus organismos autónomos. Además, el interlocutor/a debería formar parte de una entidad que cumpla los requisitos para inscribirse previamente en este registro. Será el concejal/a, directivo/a o trabajador/a eventual quien valore, en función del contenido de dicha conversación, la necesidad de inscribirse y debería advertírselo a la persona con la que converse",
                position: 7)
Question.create(title: "¿La inscripción supone alguna obligación?",
                answer: "La inscripción implica aceptar el código de conducta y todas las obligaciones que aparecen en la Ordenanza de Transparencia de la Ciudad de Madrid. Afecta a todos los sujetos que ejerzan la actividad de lobby y a las entidades inscritas en el Registro de Entidades Ciudadanas que lleven a cabo actividad de lobby
                La inscripción supone, asimismo, el compromiso de no hacer regalos no permitidos según lo dispuesto en el Acuerdo de 5 de noviembre de 2015 de la Junta de Gobierno de la Ciudad de Madrid. Así, se establece el régimen de regalos que reciban el alcalde, los miembros de la Junta de Gobierno, los concejales con responsabilidades de gobierno, los concejales-presidentes de los distritos, los titulares de los órganos directivos y los empleados públicos del Ayuntamiento de Madrid y sus organismos autónomos.",
                position: 8)
Question.create(title: "¿Puede alguien que vaya a ejercer lobby representar a varias personas o entidades? ¿Cómo se refleja esto en el Registro de Lobbies de la Ciudad de Madrid?",
                answer: "Sí. En el Registro de Lobbies se puede consultar qué personas pueden mantener reuniones por cuenta de cada persona o entidad inscrita.",
                position: 9)
Question.create(title: "¿Qué información se debe dar para inscribirse en el Registro de Lobbies?",
                answer: "En primer lugar, una declaración responsable con los datos mínimos de quién ejerce la actividad de lobby y las personas o entidades representadas. En segundo lugar, para completar la inscripción, hay que incluir información adicional relacionada con quien  haya presentado la declaración dentro de la aplicación del Registro.",
                position: 10)
Question.create(title: "¿Cuánto se tarda en inscribirse en el Registro de Lobbies de la Ciudad de Madrid?",
                answer: "La inscripción puede formalizarse en un tiempo muy breve siempre que se faciliten todos los datos necesarios. El procedimiento está pensado para que sea sencillo y ágil.",
                position: 11)
Question.create(title: "¿La inscripción debe ser confirmada o se confirma al acabar de registrar los datos?",
                answer: "No, no es necesario.",
                position: 12)
Question.create(title: "¿Qué ventajas tiene registrarse en el Registro de Lobbies?",
                answer: "El lobby se puede incluir en listas de distribución de contenidos relacionados con las áreas de actividad o interés que haya manifestado, con el fin de facilitar su participación. También podrá solicitar reuniones y encuentros a través del registro con aquellos/as responsables municipales que mantengan agenda institucional.
                La información relativa a los procedimientos en los que haya intervenido podrá incluir una mención expresa de su participación.",
                position: 13)
Question.create(title: "¿Se publicará toda la información que entregue durante mis reuniones con el Ayuntamiento de Madrid?",
                answer: "No necesariamente. Los documentos principales que sirvan de soporte para la celebración de las reuniones o encuentros con lobbies y que sean suministrados por ellos, se publicarán teniendo en cuenta los límites contemplados en la Ley 19/2013, de 9 de diciembre, de Transparencia, Acceso a la Información pública y Buen Gobierno. El lobby podrá decidir si quiere que una parte de la información suministrada no se publique por afectar a sus intereses económicos o    comerciales, a la debida confidencialidad que deba guardarse o cualquier otro límite. Esta alegación se valorará teniendo en cuenta el interés general en la divulgación de la información pública aportada y los intereses manifestados por el lobby.",
                position: 14)
Question.create(title: "¿Solo se publicará la información sobre reuniones que se celebren en dependencias oficiales del Ayuntamiento de Madrid?",
                answer: "No, necesariamente. La actividad de lobby puede llevarse a cabo con independencia del lugar en el que se realice, ya se trate de dependencias municipales o no.",
                position: 15)
Question.create(title: "¿La información sobre las reuniones que se mantienen con el Ayuntamiento de Madrid también es pública?",
                answer: "Sí, ya lo es desde 2015, tras la aprobación de los acuerdos de la Junta de Gobierno sobre la publicación de las agendas institucionales. En mayo de 2016 se puso en marcha la aplicación actual para publicar esta información.",
                position: 16)
Question.create(title: "¿Cómo se puede saber quién ha llevado a cabo actividad de lobby en el Ayuntamiento de Madrid?",
                answer: "Existirá la posibilidad de consultar la agenda institucional para conocer qué reuniones se han mantenido con objeto de hacer lobby. También será posible conocer esta información en el espacio del portal de transparencia dedicado al Registro de Lobbies.",
                position: 17)
Question.create(title: "¿Dónde se puede inscribir alguien en el Registro de Lobbies?",
                answer: "En el espacio de inscripción en el Portal de Transparencia.",
                position: 18)
Question.create(title: "¿Se puede registrar presencialmente en el Registro de Lobbies?",
                answer: "La declaración responsable solo se podrá presentar electrónicamente. Se podrá presentar también en un registro presencial, pero la información adicional para completar el proceso de inscripción deberá completarse necesariamente en la aplicación del Registro de Lobbies",
                position: 19)
Question.create(title: "¿Hace falta identificarse electrónicamente para registrarse?",
                answer: "Sí, es necesario.",
                position: 20)
Question.create(title: "¿Cómo se puede solicitar la baja en el registro?",
                answer: "Para solicitar la baja, deberá presentarse una declaración responsable.",
                position: 21)
Question.create(title: "¿Existe algún control sobre aquellos que no cumplen con las obligaciones del registro?",
                answer: "La inexactitud, falsedad u omisión, de carácter esencial, de cualquier dato o información que se incorpore a la declaración responsable o el no presentar la documentación requerida para acreditar que se cumple lo declarado, determinará la baja en el registro, perder los incentivos y la posibilidad de mantener reuniones con concejales, directivos y el personal eventual. La Comisión de Seguimiento de la Ordenanza de Transparencia controlará que los concejales, directivos   y el personal eventual no celebren reuniones ni encuentros con personas no inscritas en el Registro de Lobbies, cuando las reuniones tengan por objeto actividades sujetas a registro. Se articulará un buzón electrónico para que se puedan comunicar de manera anónima los incumplimientos de lo dispuesto en la regulación municipal sobre lobby. De estas comunicaciones se dará cuenta a la Comisión de Seguimiento.",
                position: 22)
Question.create(title: "¿Debo estar registrado en el Registro de Lobbies antes de mantener una reunión con el Ayuntamiento de Madrid?",
                answer: "Los concejales, directivos y personal eventual, antes de celebrar cualquier reunión, encuentro o comunicación con personas o entidades que vayan a ejercer lobby, deben verificar previamente que están inscritas en el registro. En caso de comprobar que no lo están, no podrá llevarse a cabo la reunión, encuentro o comunicación mientras no se registren.",
                position: 23)
Question.create(title: "¿Qué sucede si durante una reunión, quiero plantear alguna cuestión que me obligaría a estar inscrito en el Registro de Lobbies y no lo estoy?",
                answer: "Si en el curso de una reunión, encuentro o comunicación se apreciara que la persona o entidad lleva a cabo alguna actividad que exija el previo registro, habrá que advertir expresamente de esta circunstancia y finalizar en ese mismo momento el encuentro.",
                position: 24)
Question.create(title: "¿Qué otras ciudades o instituciones cuentan con un registro de lobbies?",
                answer: "Actualmente funcionan registros similares en la Comunidad Autónoma de Cataluña y en la Comisión Nacional de los Mercados y de la Competencia (en este caso, la inscripción es voluntaria). Algunas Comunidades Autónomas, como Castilla-La Mancha, lo incluyen en su normativa, pero aún no funciona.",
                position: 25)

puts "Faq created ✅"
