import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/objects/contact.dart';
import 'package:contact_app/objects/user_model.dart';
import 'package:contact_app/pages/contact_new_screen.dart';
import 'package:contact_app/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactsPage extends StatefulWidget{
  static String id = 'contacts_page';


  @override
  _ContactsPageState createState() => _ContactsPageState();
}

final contactReference = FirebaseDatabase.instance.reference().child('contactos');

class _ContactsPageState extends State<ContactsPage> {
  List<Contact>? items;
  late StreamSubscription<Event> _onContactAddedSubscription;
  late StreamSubscription<Event> _onContactChangeSubscription;

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    items = new List.empty(growable: true);
    _onContactAddedSubscription = contactReference.onChildAdded.listen(_onContactAdded);
    _onContactChangeSubscription = contactReference.onChildAdded.listen(_onContactUpdate);

    FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value) {
        this.loggedInUser = UserModel.fromMap(value.data());
        setState(() {

        });
      });
    super.initState();
  }
  @override
  void dispose() {
    _onContactAddedSubscription.cancel();
    _onContactChangeSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Imagen logo
                      SizedBox(
                        height: 70,
                        child: Image.asset("assets/logo.jpg", fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${loggedInUser.name} ${loggedInUser.lastName}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    Text("${loggedInUser.email}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ActionChip(label: Text("Cerrar Sesión"), onPressed: () {
                      logout(context); Fluttertoast.showToast(msg: "Sesión cerrada");
                    }),
                  ],
                ),
              ],
            ),
          ),
          body: CustomScrollView(
            physics: ScrollPhysics(),
            primary: true,
            slivers: [
              SliverAppBar(
                title: Text("Contactos"),
                backgroundColor: Colors.teal,
                floating: true,
                centerTitle: true,
              ),

              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int position){
                        //_cardContact(position);
                        //print("nombre"+items![position].name.toString());
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 10.0,
                          child: Row(
                            children: [
                              Image.asset('assets/contacto.png',
                                height: 65.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(items![position].name.toString(),
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                              SizedBox(
                                width: 60.0,
                              ),
                              _buttonEdit(position),
                              _buttonDelete(position),
                            ],
                          ),
                        );
                      },
                    childCount: items?.length,
                  ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(FontAwesomeIcons.plus),
            elevation: 15.0,
            backgroundColor: Colors.teal,
            onPressed: ()=> _createNewContact(context),
          ),
        ),
    );
  }

  void _onContactAdded(Event event){
    setState(() {
      items!.add(new Contact.fromSnapShot(event.snapshot));
    });
  }

  void _onContactUpdate(Event event){
    var oldContactValue = items!.singleWhere((contact) => contact.id == event.snapshot.key);
    setState(() {
      items![items!.indexOf(oldContactValue)] = new Contact.fromSnapShot(event.snapshot);
    });
  }

  void _navigateToContactInformation(BuildContext context, Contact contact) async{
    //await Navigator.push(context, MaterialPageRoute(builder: build));
    await Navigator.push(context,
      MaterialPageRoute(builder:
          (context) => ContactNewScreen(Contact( contact.id, contact.name, contact.phone, contact.address),),
      ),
    );
  }

  void _deleteContact(BuildContext context, Contact contact, int position) async{
    await contactReference.child(contact.id.toString()).remove().then((_) {
      setState(() {
        items!.removeAt(position);
        Fluttertoast.showToast(msg: "Contacto Eliminado");
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ContactsPage()));
      });
    },);
  }

  void _createNewContact(BuildContext context) async{
    await Navigator.push(context,
      MaterialPageRoute(builder:
      (context) => ContactNewScreen(Contact( null, '', '', ''),),
      ),
    );
  }

  Widget _buttonEdit(int position) {
    return IconButton(
      icon: Icon(Icons.edit,
      color: Colors.blueAccent,
      ),
      onPressed: ()=>_navigateToContactInformation(context, items![position]),
    );
  }

  Widget _buttonDelete(int position) {
    return IconButton(
      icon: Icon(Icons.delete),
      color: Colors.red,
      onPressed: () => _deleteContact(context, items![position], position),);
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  /*Widget _cardContact(int position) {
    return Card(
        color: Colors.red,
        elevation: 10.0,
        child: Row(
          children: [

            //Text(items![position].name.toString()),
            //Text(position.toString()),
          ],
        ),
    );
  }*/
}

