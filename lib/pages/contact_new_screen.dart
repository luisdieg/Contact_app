import 'package:contact_app/objects/contact.dart';
import 'package:contact_app/pages/contacts_page.dart';
import 'package:contact_app/widgets/side_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactNewScreen extends StatefulWidget {
  final Contact? contact;
  ContactNewScreen(this.contact);

  @override
  _ContactNewScreenState createState() => _ContactNewScreenState();
}

class _ContactNewScreenState extends State<ContactNewScreen> {
  List<Contact>? items;
  TextEditingController? _name;
  TextEditingController? _phone;
  TextEditingController? _address;

  @override
  void initState() {
    _name = TextEditingController(
        text: widget.contact!.name
    );
    _phone = TextEditingController(
        text: widget.contact!.phone
    );
    _address = TextEditingController(
        text: widget.contact!.address
    );
    super.initState();
  }

  void dispose() {
    _name!.dispose();
    _phone!.dispose();
    _address!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: (widget.contact!.id != null)
                ? _TextLabel(
              label: 'Editar Contacto',
              colorletter: Colors.white,
            )
                : _TextLabel(
              label: 'Nuevo Contacto',
              colorletter: Colors.white,
            ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        //drawer: SideBarWidget(),
        body: Center(
          child: Container(
            height: 600.0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 20.0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: (widget.contact!.id != null)
                        ? _TextLabel(label: "Editar Contacto")
                    //_TextLabel(label: "Editar Contacto")
                        : _TextLabel(label: "Nuevo Contacto"),
                    //_TextLabel(label: "Nuevo Contacto")
                  ),
                  _nameContact(),
                  _phoneContact(),
                  _addressContact(),
                  SizedBox(
                    width: 10.0,
                    height: 10.0,
                  ),
                  _buttonContact(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameContact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: _name,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.contact_page_sharp,
            color: Colors.teal,
          ),
          labelText: "Nombre del contacto",
          labelStyle: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget _phoneContact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _phone,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.phone,
            color: Colors.teal,
          ),
          labelText: "Número de teléfono",
          labelStyle: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget _addressContact() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        maxLines: 3,
        controller: _address,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.home,
            color: Colors.teal,
          ),
          labelText: "Domicilio del contacto",
          labelStyle: TextStyle(
            color: Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget _buttonContact() {
    return TextButton(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 80.0,
          vertical: 15.0,
        ),
        child: (widget.contact!.id != null)
            ? _TextLabel(
          label: 'Actualizar',
          colorletter: Colors.white,
        )
            : _TextLabel(
          label: 'Agregar',
          colorletter: Colors.white,
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.teal,
      ),
      onPressed: () {
        setState(() {
          _addContact();
        });
      },
    );
  }

  void _addContact() {
    try {
      if (widget.contact!.id != null) {
        contactReference.child(widget.contact!.id.toString()).set({
          'name': _name!.text,
          'phone': _phone!.text,
          'address': _address!.text,
        }).then((_) => {
          Fluttertoast.showToast(msg: "Contacto Editado Correctamente"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ContactsPage())),
        });
      } else {
        contactReference.push().set({
          'name': _name!.text,
          'phone': _phone!.text,
          'address': _address!.text,
        }).then((_) => {
          Fluttertoast.showToast(msg: "Contacto Agregado Correctamente"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ContactsPage())),
        });
      }
    }
    catch (e) {
      _showDialog(context);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ha ocurrido un ERROR."),
          actions: [
            Expanded(
              child: TextButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
      context: context,
    );
  }
}


class _TextLabel extends StatelessWidget {
  final String label;
  Color colorletter;
  _TextLabel({required this.label, this.colorletter = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: colorletter,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}