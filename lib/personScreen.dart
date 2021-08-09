import 'package:flutter/material.dart';

import 'models/person.dart';
import 'services/TVServices.dart';

class PersonDetails extends StatefulWidget {
  const PersonDetails({Key? key, required this.id}) : super(key: key);

  final id;

  @override
  _PersonDetailsState createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  Person person = Person(name: '', id: 0, image: '', country: '', birthday: '');

  void fetchPersonDetails() async {
    person = await TVServices().getPersonDetails(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchPersonDetails();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.purple[800],
        ),
        title: Text(
          'TV Shows App',
          style: TextStyle(color: Colors.purple[800]),
        ),
      ),
      body: person.name == ''
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.purple[800],
              ),
            )
          : Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(2, 2))
                        ],
                        border: Border.all(
                            width: 2, color: Colors.purple.withOpacity(.2)),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: person.image != ''
                            ? Image(
                                image: NetworkImage(person.image),
                                fit: BoxFit.fitWidth)
                            : Image(
                                image: AssetImage('assets/person.png'),
                              ),
                      ),
                    ),
                  ),
                ),
                Text(person.name, style: Theme.of(context).textTheme.headline2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Country: ${person.country}',
                          style: Theme.of(context).textTheme.bodyText1),
                      Text('Birthday: ${person.birthday}',
                          style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                )
              ],
            ));
}
