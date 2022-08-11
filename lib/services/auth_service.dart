import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/pages/models/login_response.dart';
import 'package:chat/pages/models/usuarios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {

  late Usuario usuario;

  // Create storage
 final _storage =  const FlutterSecureStorage();

  bool _autenticando = false;

  bool get autenticando =>_autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //Getter del token de forma estática 

  static Future<String?> getToken() async {
    const _storage =   FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

    static Future<void> deleteToken() async {
    const _storage =   FlutterSecureStorage();
    await _storage.delete(key: 'token');

  }

  Future<bool> login(String email, String password) async {

    autenticando = true; 

    final data = {
      'email' : email,
      'password' : password
    };

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login' ), 
      body: jsonEncode(data),
      headers: {
        'Content-Type' : 'application/json'
      }
    
    );

    autenticando = false;
    if(resp.statusCode == 200) {
      
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      
      return true;
    }else {
      
      return false;
    }
    
    
  }

  Future register(String name, String email, String password) async {
    autenticando = true; 

    final data = {
      'nombre' :name, 
      'email' : email,
      'password' : password
    };

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new' ), 
      body: jsonEncode(data),
      headers: {
        'Content-Type' : 'application/json'
      }
    
    );

    autenticando = false;
    if(resp.statusCode == 200) {
      
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      
      return true;
    }else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }


  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew' ),       
      headers: {
        'Content-Type' : 'application/json',
        'x-token': token??''
      }
    
    );


     if(resp.statusCode == 200) {
      
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);
      
      return true;
    }else {
      logout();
      return false; 
    }
  }
  
  Future _guardarToken (String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }
  
  Future logout( ) async {
    
    // Delete value
    await _storage.delete(key: 'token');
  }

}