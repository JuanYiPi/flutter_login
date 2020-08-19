import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
    
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.favorite_border), onPressed: (){}),
          IconButton(icon: Icon(Icons.search), onPressed: (){}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){})
        ],
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton( context ),
    );
  }

  Widget _crearListado() {

    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem( context, productos[i] ),
          );

        } else {
          return Center( child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem( BuildContext context, ProductoModel producto ) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.blueAccent,
      ),
      onDismissed: ( direccion ){
        productosProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[

            ( producto.fotosUrl == null )
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                image: NetworkImage( producto.fotosUrl ),
                placeholder: AssetImage('assets/cargando.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            ListTile(
              title: Text('${ producto.titulo } - ${ producto.valor }'),
              subtitle: Text( producto.id ),
              onTap: () => Navigator.pushNamed( context, 'producto', arguments: producto ).then((value) { setState(() {});}),
            ),
          ],
        ),
      )
    );

    
  }

  _crearBoton( BuildContext context ) {

    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: Icon( Icons.add ),
      onPressed: () => Navigator.pushNamed(context, 'producto').then((value) { setState(() {});}),
    );
  }
}