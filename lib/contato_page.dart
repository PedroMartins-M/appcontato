import 'package:flutter/material.dart';

class ContatoPage extends StatelessWidget {
  const ContatoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Contatos"),
        centerTitle: true,
      ),

      body: ListView(
        padding: EdgeInsets.all(12),
        children: [

          Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  "AS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                     color: Colors.white
                  ),
                ),
              ),
              title: Text('Ana Souza'),
              subtitle: Text("(11) 98765-4321"),
              trailing: Icon(Icons.star,),
              iconColor: Colors.amber,
            ),
          ),

              Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Text(
                  "BL",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                     color: Colors.white
                  ),
                ),
              ),
              title: Text('Bruno Lima'),
              subtitle: Text("(11) 31232-2312"),
              trailing: Icon(Icons.star),
            ),
          ),

              Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber,
                child: Text(
                  "CM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                     color: Colors.white
                  ),
                ),
              ),
              title: Text('Carla Mendes'),
              subtitle: Text("(21) 97654-3210"),
              trailing: Icon(Icons.star),
              iconColor: Colors.amber,
            ),
          ),

              Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.lightGreen,
                child: Text(
                  "An",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                     color: Colors.white
                  ),
                ),
              ),
              title: Text('Diego Alves'),
              subtitle: Text("(11) 988888-1234"),
              trailing: Icon(Icons.star),
            ),
          ),

             Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurpleAccent,
                child: Text(
                  "ET",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.white
                  ),
                ),
              ),
              title: Text('Elisa Torres'),
              subtitle: Text("(17) 99999-5678"),
              trailing: Icon(Icons.star),
            ),
          ),
        ],
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