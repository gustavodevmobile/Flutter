// Core validators (example)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validators {
  static bool isEmail(String email) =>
      RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(email);

  static bool isCpf(String cpf) =>
      RegExp(r'^([0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}|[0-9]{11})$')
          .hasMatch(cpf);

  static bool isCnpj(String cnpj) =>
      RegExp(r'^(\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}|\d{14})$').hasMatch(cnpj);

  static bool isCrp(String crp) =>
      RegExp(r'^\d{2}/\d{6}$').hasMatch(crp);

  

  
}
