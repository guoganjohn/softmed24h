import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  final List<String> questions = [
    'O que é o TeleClin?',
    'Qual o valor da consulta?',
    'Há carência ou fidelidade?',
    'Como funciona o atendimento médico?',
    'Pago algo além dos R\$ 49,90?',
    'A empresa em que trabalho pode se negar a aceitar o atestado?',
    'Como saber se o médico é um médico mesmo?',
    'Posso utilizar o meu cadastro para um familiar?',
  ];

  final List<String> answers = [
    'TeleClin é uma plataforma de telemedicina que oferece consultas médicas 24h por dia, sem sair de casa, por apenas R\$ 49,90.',
    'O valor da consulta é de R\$ 49,90.',
    'Não há carência nem fidelidade. Você usa quando precisar.',
    'O atendimento é feito por videochamada, a qualquer hora do dia ou da noite, com médicos qualificados.',
    'Não. O valor de R\$ 49,90 é o valor final da consulta.',
    'A empresa não pode se negar a aceitar o atestado, desde que seja emitido por um médico.',
    'Todos os médicos da plataforma são devidamente registrados nos conselhos regionais de medicina.',
    'Sim, você pode utilizar o seu cadastro para um familiar.',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'DÚVIDAS FREQUENTES:',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 20),
          ExpansionPanelList.radio(
            expansionCallback: (int index, bool isExpanded) {},
            children: List.generate(questions.length, (index) {
              return ExpansionPanelRadio(
                value: index,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(
                      '${index + 1} - ${questions[index]}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 600
                            ? 14
                            : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      answers[index],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 600
                            ? 12
                            : 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                canTapOnHeader: true,
              );
            }),
          ),
        ],
      ),
    );
  }
}
