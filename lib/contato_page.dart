import 'package:appcontato/sobre_page.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  List<Map<String, dynamic>> contatos = [];
  String? filtroAtual;

  // Lista de Categorias
  static const List<String> categorias = [
    'Pessoal',
    'Trabalho',
    'Família',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    carregarContatos();
  }

  Future<void> carregarContatos() async {
    final dados = await DatabaseHelper.obterContatos(filtro: filtroAtual);
    setState(() {
      contatos = dados;
    });
  }

  Future<void> marcarFavorito(int id, bool favoritoAtual) async {
    await DatabaseHelper.alternarFavorito(id, !favoritoAtual);
    await carregarContatos();
  }

  void aplicarFiltro(String? novoFiltro) {
    filtroAtual = novoFiltro;
    Navigator.pop(context);
    carregarContatos();
  }

  // 1. DIÁLOGO COM DROPDOWN DE CATEGORIA
  void adicionarContato() {
    final adicionarNome = TextEditingController();
    final adicionarTelefone = TextEditingController();
    String categoriaSelecionada = categorias.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: const Text('Novo Contato'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: adicionarNome,
                      decoration: const InputDecoration(
                        hintText: "Nome do contato...",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: adicionarTelefone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: "Telefone..."),
                    ),
                    const SizedBox(height: 10),
                    // Dropdown de Categoria
                    DropdownButtonFormField<String>(
                      value: categoriaSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                      ),
                      items: categorias.map((String cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (novoValor) {
                        if (novoValor != null) {
                          setStateModal(() {
                            categoriaSelecionada = novoValor;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final nome = adicionarNome.text.trim();
                    final telefone = adicionarTelefone.text.trim();

                    if (nome.isNotEmpty) {
                      await DatabaseHelper.inserirContato(
                        nome,
                        telefone.isNotEmpty ? telefone : 'Sem telefone',
                        categoriaSelecionada,
                      );

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                "Meus Contatos",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Todos os seus contatos"),
              selected: filtroAtual == null,
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro(null),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favoritos'),
              selected: filtroAtual == 'favoritos',
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro('favoritos'),
            ),
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Normais'),
              selected: filtroAtual == 'normais',
              selectedColor: Colors.blue[700],
              onTap: () => aplicarFiltro('normais'),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Sobre o Aplicativo"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SobrePage()),
                );
              },
            ),
          ],
        ),
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
                final String telefone = contato['telefone'] ?? '';
                final String categoria = contato['categoria'] ?? 'Geral';

                final String inicial = nome.length >= 2
                    ? nome.substring(0, 2).toUpperCase()
                    : nome.toUpperCase();

                return Dismissible(
                  key: Key(contato['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) async {
                    final id = contato['id'];
                    await DatabaseHelper.excluirContato(id);

                    setState(() {
                      contatos.removeAt(index);
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$nome removido com sucesso')),
                      );
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          inicial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(nome),
                      // 2. EXIBIÇÃO DO TELEFONE E DA CATEGORIA LADO A LADO
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Text(
                              telefone,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blueGrey.shade100,
                              ),
                            ),
                            child: Text(
                              categoria,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blueGrey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () =>
                            marcarFavorito(contato['id'], favorito),
                        icon: Icon(
                          Icons.star,
                          color: favorito ? Colors.amber : Colors.grey,
                        ),
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