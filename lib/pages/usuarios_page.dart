import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import 'package:chat/pages/models/usuarios.dart';

class UsuariosPage extends StatefulWidget {


   
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
   RefreshController _refreshController =  RefreshController (initialRefresh: false);   

  final usuarios = [
  Usuario(online: true, email: 'Javier@test.com', nombre: 'Javier', uid: '1'),
  Usuario(online: true, email: 'Jonathan@test.com', nombre: 'Jonathan', uid: '2'),
  Usuario(online: true, email: 'Ian@test.com', nombre: 'Ian', uid: '3'),
  Usuario(online: false, email: 'Jorge@test.com', nombre: 'Jorge', uid: '4'),
];
  
  @override
  Widget build(BuildContext context) {
  final authService = Provider.of<AuthService>(context);
  final usuario = authService.usuario;
    return  Scaffold(
      appBar: AppBar(
      title:  Text(usuario.nombre, style: const TextStyle(color: Colors.black54,)),
      elevation: 1,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: (){
          //TODO: Desconocectar del socket service
          Navigator.pushReplacementNamed(context, 'login');
          AuthService.deleteToken();
          
        }, 
        icon: const Icon(Icons.exit_to_app, color: Colors.black54)
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 10),
         // child: Icon(Icons.check_circle, color: Colors.blue[400],),
         child: const Icon(Icons.offline_bolt, color: Colors.red,),

        )
      ],
      ),
      
      body: SmartRefresher(
        controller: _refreshController,
        child: _listviewUsuarios(),
        onRefresh: _cargarUsuarios,
        enablePullDown: true,
        header: WaterDropHeader(
          complete:  Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue[400]!,
        ),
      ),
    );
  }

  ListView _listviewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, int i) => Divider(),
      itemBuilder: (_, int i) => _usuarioListTile(usuario: usuarios[i])
    );
  }

  _cargarUsuarios() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();

  }
}

class _usuarioListTile extends StatelessWidget {
  const _usuarioListTile({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0,2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      
    );
  }

  
}