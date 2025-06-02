// Core validators (example)
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

  static bool isMaiorDeIdade(String dataNascimento) {
    try {
      // Extrai dia, mês e ano do formato dd/MM/yyyy
      final partes = dataNascimento.split('/');
      if (partes.length != 3) return false;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);

      final nascimento = DateTime(ano, mes, dia);
      final hoje = DateTime.now();

      final idade = hoje.year -
          nascimento.year -
          ((hoje.month < nascimento.month ||
                  (hoje.month == nascimento.month && hoje.day < nascimento.day))
              ? 1
              : 0);

      return idade >= 18;
    } catch (e) {
      return false;
    }
  }
}
