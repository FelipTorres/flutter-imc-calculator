import 'package:flutter/material.dart';

void main() => runApp(const IMCApp());

class IMCApp extends StatelessWidget {
  const IMCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      home: const IMCPagina(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IMCPagina extends StatefulWidget {
  const IMCPagina({super.key});

  @override
  State<IMCPagina> createState() => _IMCPaginaState();
}

class _IMCPaginaState extends State<IMCPagina> {
  final TextEditingController _controladorPeso = TextEditingController();
  final TextEditingController _controladorAltura = TextEditingController();
  double? _valorIMC;
  String _descricaoIMC = "";
  Color _corDescricao = Colors.black;

  void _executarCalculo() {
    final double? peso = double.tryParse(_controladorPeso.text);
    final double? altura = double.tryParse(_controladorAltura.text);

    if (peso == null || altura == null || altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos')),
      );
      return;
    }

    final double imcCalculado = peso / (altura * altura);

    setState(() {
      _valorIMC = imcCalculado;
      _descricaoIMC = _obterClassificacao(imcCalculado);
      _corDescricao = _obterCorClassificacao(imcCalculado);
    });
  }

  void _limparDados() {
    setState(() {
      _controladorPeso.clear();
      _controladorAltura.clear();
      _valorIMC = null;
      _descricaoIMC = "";
      _corDescricao = Colors.black;
    });
  }

  String _obterClassificacao(double imc) {
    if (imc < 18.5) return "Abaixo do peso";
    if (imc < 24.9) return "Peso ideal";
    if (imc < 29.9) return "Sobrepeso";
    if (imc < 34.9) return "Obesidade grau I";
    if (imc < 39.9) return "Obesidade grau II";
    return "Obesidade grau III";
  }

  Color _obterCorClassificacao(double imc) {
    if (imc < 18.5) return Colors.blueAccent;
    if (imc < 24.9) return Colors.green;
    if (imc < 29.9) return Colors.orange;
    if (imc < 34.9) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorPeso,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controladorAltura,
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _executarCalculo,
                  child: const Text('Calcular'),
                ),
                ElevatedButton(
                  onPressed: _limparDados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Limpar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_valorIMC != null)
              Column(
                children: [
                  Text(
                    'Seu IMC é: ${_valorIMC!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _descricaoIMC,
                    style: TextStyle(
                      fontSize: 22,
                      color: _corDescricao,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
