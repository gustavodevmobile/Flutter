class Validador {

  static bool validarCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false; // Todos iguais

    // Validação do primeiro dígito
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int digito1 = 11 - (soma % 11);
    if (digito1 >= 10) digito1 = 0;
    if (digito1 != int.parse(cpf[9])) return false;

    // Validação do segundo dígito
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int digito2 = 11 - (soma % 11);
    if (digito2 >= 10) digito2 = 0;
    if (digito2 != int.parse(cpf[10])) return false;

    return true;
  }

  static bool validarCNPJ(String cnpj) {
  // Remove caracteres não numéricos
  cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

  if (cnpj.length != 14) return false;
  if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false; // Todos iguais

  List<int> multiplicador1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  List<int> multiplicador2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  // Primeiro dígito
  int soma = 0;
  for (int i = 0; i < 12; i++) {
    soma += int.parse(cnpj[i]) * multiplicador1[i];
  }
  int resto = soma % 11;
  int digito1 = resto < 2 ? 0 : 11 - resto;

  // Segundo dígito
  soma = 0;
  for (int i = 0; i < 13; i++) {
    soma += int.parse(cnpj[i]) * multiplicador2[i];
  }
  resto = soma % 11;
  int digito2 = resto < 2 ? 0 : 11 - resto;

  return digito1 == int.parse(cnpj[12]) && digito2 == int.parse(cnpj[13]);
}
}