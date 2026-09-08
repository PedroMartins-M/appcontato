import 'package:flutter/material.dart';
import 'database_helper.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  List<Map<String, dynamic>> contatos = [];

  @override
  void initState() {
    super.initState();
    carregarContatos(); // Carrega os dados ao abrir a tela
  }

  // Busca os contatos do Banco de Dados
  Future<void> carregarContatos() async {
    final dados = await DatabaseHelper.obterContatos();
    setState(() {
      contatos = dados;
    });
  }

  // Marcar/Desmarcar Favorito no Banco
  Future<void> marcarFavorito(int id, bool favoritoAtual) async {
    await DatabaseHelper.alternarFavorito(id, !favoritoAtual);
    await carregarContatos();
  }

  void excluirContato(int index) async{
    final contato = contatos[index];

    await DatabaseHelper.excluirContato(contato['id']);

    carregarContatos();

  }

  // Adicionar Contato com SQFlite
  void adicionarContato() {
    final adicionarNome = TextEditingController();
    final adicionarTelefone = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: adicionarNome,
                decoration: const InputDecoration(hintText: "Nome do contato..."),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: adicionarTelefone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: "Telefone..."),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Fecha o diálogo com segurança ao cancelar
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final nome = adicionarNome.text.trim();
                final telefone = adicionarTelefone.text.trim();

                if (nome.isNotEmpty) {
                  await DatabaseHelper.inserirContato({
                    'nome': nome,
                    'telefone': telefone.isNotEmpty ? telefone : 'Sem telefone',
                    'favorito': 0,
                  });

                  await carregarContatos();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Contatos"),
        centerTitle: true,
      ),
      body: contatos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum contato encontrado',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];
                final bool favorito = contato['favorito'] == 1;
                final String nome = contato['nome'] ?? '';
                final String inicial = nome.length >= 2 
                    ? nome.substring(0, 2).toUpperCase() 
                    : nome.toUpperCase();

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        inicial,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(nome),
                    subtitle: Text(contato['telefone'] ?? ''),
                    trailing: IconButton(
                      onPressed: () => marcarFavorito(contato['id'], favorito),
                      icon: Icon(
                        Icons.star,
                        color: favorito ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarContato,
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}