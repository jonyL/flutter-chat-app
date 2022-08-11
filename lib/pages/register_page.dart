// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/boton_azul.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels_input.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
   
  const RegisterPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(     
          physics: const BouncingScrollPhysics(),     
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    const Logo(titulo: 'Registro'),
                    _Form(),
                    const Labels(ruta: 'login', text: '¿Ya tienes cuenta?', textLink: 'Ingresa ahora',), 
                    const Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),),
                ],
              ),
          ),
        ),
      )
    );
  }
}



class _Form extends StatefulWidget {  

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

        CustomInput(
          icon: Icons.perm_identity,
          placeholder: 'Nombre',
          keyboardType: TextInputType.text,
          textController: nameCtrl,
        ),

        CustomInput(
          icon: Icons.mail_outline,
          placeholder: 'Correo',
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),

        CustomInput(
          icon: Icons.lock_outline,
          placeholder: 'Contraseña',          
          textController: passCtrl,
          isPassword: true,
        ),
          
          BotonAzul(
            onPress: authService.autenticando ? null : () async {                   
              FocusScope.of(context).unfocus(); //Quita el foco de donde esté y esconde el teclado    
              final registerOk = await authService.register(nameCtrl.text.trim(),  emailCtrl.text.trim(), passCtrl.text.trim());
              if( registerOk == true) {
                //TODO: Conectar a nuestro socket server

                Navigator.pushReplacementNamed(context, 'usuarios');
              }else {
                mostrarAlerta(context, 'Registro incorrecto', registerOk);
              }
            },
            text: 'Registrar',
          )

          
      
        ],
      ),
    );
  }
}


