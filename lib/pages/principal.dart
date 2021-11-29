import 'package:express/models/usuario.dart';
import 'package:express/widgets/custom_button.dart';
import 'package:express/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:express/services/auth_service.dart';
import 'package:provider/provider.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  List<Usuario> response = [];

  final nomCtrl = TextEditingController();
  final apeCtrl = TextEditingController();
  TextInputType keyboardType = TextInputType.text;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    Future getUsers() async {
      authService.getUser().then(
        (value) {
          response = value;
          setState(() {});
        },
      );
    }

    getUsers();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Examen Unidad 2',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            CustomInput(
              icono: Icons.person,
              placeHolder: 'Ingrese Nombre',
              keyboardType: TextInputType.text,
              textController: nomCtrl,
            ),
            CustomInput(
              icono: Icons.person,
              placeHolder: 'Ingrese Apellido',
              keyboardType: TextInputType.text,
              textController: apeCtrl,
            ),
            //ElevatedButton(onPressed: () {}, child: Text('Iniciar')),
            CustomButton(
              texto: 'Enviar',
              onPressed: authService.autenticando
                  ? () => {}
                  : () async {
                      FocusScope.of(context).unfocus();
                      final loginRes =
                          await authService.login(nomCtrl.text, apeCtrl.text);
                      if (loginRes) {
                        Navigator.pushReplacementNamed(context,
                            'usuarios'); // no permite regresar al login
                      }
                    },
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: response
                    .map((e) => Text(
                          '${e.nombre} ${e.apellido}',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
