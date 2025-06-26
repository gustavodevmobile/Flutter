import 'package:flutter/material.dart';

class PaymentSimulationScreen extends StatefulWidget {
  const PaymentSimulationScreen({super.key});

  @override
  State<PaymentSimulationScreen> createState() =>
      _PaymentSimulationScreenState();
}

class _PaymentSimulationScreenState extends State<PaymentSimulationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  bool _isPaying = false;
  bool _success = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _simulatePayment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isPaying = true;
      _success = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isPaying = false;
      _success = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento (Simulação)'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Checkout',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Valor a pagar',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ 120,00',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome no cartão',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe o nome' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cardController,
                      decoration: const InputDecoration(
                        labelText: 'Número do cartão',
                        border: OutlineInputBorder(),
                        hintText: '1234 5678 9012 3456',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 19,
                      validator: (v) =>
                          v == null || v.length < 16 ? 'Número inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'Validade',
                              border: OutlineInputBorder(),
                              hintText: 'MM/AA',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            validator: (v) =>
                                v == null || v.length != 5 ? 'Ex: 12/25' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cvcController,
                            decoration: const InputDecoration(
                              labelText: 'CVC',
                              border: OutlineInputBorder(),
                              hintText: '123',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            validator: (v) => v == null || v.length < 3
                                ? 'CVC inválido'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isPaying ? null : _simulatePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: _isPaying
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Pagar'),
                      ),
                    ),
                    if (_success)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 28),
                            SizedBox(width: 8),
                            Text('Pagamento realizado!',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
