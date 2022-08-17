import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online, 
  Offline, 
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket  _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket; 

 


  void connect() async{

    final token = await AuthService.getToken();
     // Dart client
     
    _socket = IO.io(Environment.socketUrl, {
      'transports' : ['websocket'], 
      'autoConnect' : true,
      'forceNew' : true,
      'extraHeaders' : {
        'x-token' : token
      }
    });

    
    
    _socket.onConnect((_) {      
      _serverStatus = ServerStatus.Online;
      print('llamando connect');
      notifyListeners();
    });

    print(_socket.connected);
    
    _socket.onDisconnect((_) {
       _serverStatus = ServerStatus.Offline;
       print('llamando disconnect');
      notifyListeners();
    });

    

    //  socket.on( 'nuevo-mensaje' , (payload) {
    //   print(' Nuevo mensaje:  ${payload}');
    // });
     
  }

  void disconnect() {
    _socket.disconnect();
  }

}