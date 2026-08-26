import 'package:flutter/material.dart';

class ContatoPage extends StatelessWidget {
  const ContatoPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final List<Map<String, dynamic>> contatos = [

      {'inicial' : 'AS', 'nome' : 'Ana Souza', 'cor' : Colors.blueAccent, 'telefone' : '(11) 98765-4321', 'favorito' : 'true'},
      {'inicial' : 'BL', 'nome' : 'Bruno Lima', 'cor' :  Colors.blueGrey, 'telefone' : '(11) 31232-2312', 'favorito' : 'false'},
      {'inicial' : 'CM', 'nome' : 'Carla Mendes', 'cor' : Colors.amber, 'telefone' : '(21) 97654-3210', 'favorito' : 'true'},
      {'inicial' : 'An', 'nome' : 'Diego Alves', 'cor' : Colors.lightGreen, 'telefone' : '(11) 988888-1234', 'favorito' : 'false'},
      {'inicial' : 'ET', 'nome' : 'Elisa Torres', 'cor' : Colors.deepPurpleAccent, 'telefone' : '(17) 99999-5678', 'favorito' : 'false'},    
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Contatos"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: contatos.length,
        itemBuilder: (context, index) {

          final contato = contatos[index];
          final bool favorito = contato['favorito'].toString().toLowerCase() == 'true';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: contato['cor'],
                child: Text(
                  contato['inicial'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                     color: Colors.white
                  ),
                ),
              ),
              title: Text(
                contato['nome']),
              subtitle: Text(contato['telefone']),
              trailing: Icon(Icons.star,),
              iconColor: favorito ? Colors.amber : Colors.grey,
            ),
          );
        }           
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {},
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.black, 
        shape: const CircleBorder(),
      child: Icon(Icons.add ),   
      ),
    );
  }
}