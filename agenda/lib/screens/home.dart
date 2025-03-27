import 'package:agenda/datas/daoPhoneBook.dart';
import 'package:agenda/models/models_phoneBook.dart';
import 'package:agenda/widgets/boxCard.dart';
import 'package:agenda/widgets/box_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController updateName = TextEditingController();
  TextEditingController updateNumber = TextEditingController();

  final validatorName = ValidationBuilder()
      .minLength(3, 'O nome deve ter no mínimo 3 letras.')
      .maxLength(10, 'O nome deve ter no máximo 10 letras.')
      .build();

  final validatorNumber = ValidationBuilder()
      .phone('Telefone deve conter no mímino 9 números.')
      .build();

  Future<List<PhoneBook>>? _nameContact;

  void _validator() {
    if (_form.currentState!.validate()) {
      Daophonebook().save(
        PhoneBook(
          name.text,
          number.text,
        ),
      );
      name.clear();
      number.clear();
      _nameContact = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contato salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Os campos devem ser preenchidos corretamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<PhoneBook>>? dataShow() {
    if (_nameContact == null) {
      return Daophonebook().findAll();
    } else {
      return _nameContact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agenda Telefônica',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: validatorName,
                        onChanged: (nameSearch) {
                          print(nameSearch);
                          setState(
                            () {
                              if (nameSearch.isNotEmpty) {
                                _nameContact = Daophonebook().find(nameSearch);
                              } else {
                                _nameContact = null;
                              }
                            },
                          );
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          icon: const Icon(Icons.person_2_outlined),
                        ),
                        controller: name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: validatorNumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          icon: const Icon(Icons.phone),
                        ),
                        controller: number,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Color.fromARGB(192, 255, 236, 60),
                                ),
                                side: WidgetStatePropertyAll<BorderSide>(
                                    BorderSide(width: 1))),
                            onPressed: () {
                              print(_nameContact);
                              setState(() {
                                _validator();
                              });
                              // Daophonebook().findAll();
                            },
                            child: const Text('Cadastrar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: FutureBuilder<List<PhoneBook>>(
                    future: dataShow(),
                    builder: (context, snapshot) {
                      List<PhoneBook>? contacts = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          children: [
                            CircularProgressIndicator(),
                            Text('Loading...')
                          ],
                        );
                      } else if (snapshot.hasData && contacts != null) {
                        if (contacts.isNotEmpty) {
                          return ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  print(contacts[index].name);
                                },
                                child: Boxcard(
                                  IconButton(
                                    color:
                                        const Color.fromARGB(255, 143, 15, 6),
                                    onPressed: () {
                                      setState(
                                        () {
                                          Daophonebook()
                                              .delete(contacts[index].name);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Dialog(
                                            child: BoxEditDialog(
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (updateName.text ==
                                                              ' ' &&
                                                          updateNumber.text ==
                                                              ' ') {
                                                        Daophonebook().update(
                                                            updateName.text =
                                                                contacts[index]
                                                                    .name,
                                                            updateNumber.text =
                                                                contacts[index]
                                                                    .number,
                                                            contacts[index]
                                                                .name);
                                                        Navigator.pop(context);
                                                        updateName.clear();
                                                        updateNumber.clear();
                                                      } else {
                                                        Daophonebook().update(
                                                            updateName.text,
                                                            updateNumber.text,
                                                            contacts[index]
                                                                .name);
                                                        Navigator.pop(context);
                                                        updateName.clear();
                                                        updateNumber.clear();
                                                      }
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                updateName,
                                                updateNumber,
                                                contacts[index].name,
                                                contacts[index].number),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit)),
                                  contacts[index].name,
                                  contacts[index].number,
                                ),
                              );
                            },
                          );
                        }
                        return const Text(
                          'No Contacts found',
                          style: TextStyle(fontSize: 32),
                        );
                      }
                      return const Text('Error to loading Contacts');
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
