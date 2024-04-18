import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairy_smart/pages/Dairy_Cattle/breeding_status.dart';
import 'package:dairy_smart/pages/Dairy_Cattle/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CowDetailsPage extends StatefulWidget {
  final Map<String, dynamic> cowData;

  const CowDetailsPage({Key? key, required this.cowData}) : super(key: key);

  @override
  State<CowDetailsPage> createState() => _CowDetailsPageState();
}

class _CowDetailsPageState extends State<CowDetailsPage> {
  final vaccineNameController = TextEditingController();
  final vaccinatorNameController = TextEditingController();
  final reasonController = TextEditingController();
  final dosageController = TextEditingController();
  final routeController = TextEditingController();
  final manufacturerNameController = TextEditingController();
  final commentController = TextEditingController();
  DateTime? _selectedDate;


  //insemination controllers
  final technicianController = TextEditingController();
  final sourceController = TextEditingController();
  final quantityController = TextEditingController();
  final equipmentController = TextEditingController();
  final summaryController = TextEditingController();



  final _formKey = GlobalKey<FormState>();

   int _daysPregnant = 0;
   int _remainingDaysBeforeDelivery = 0;
   DateTime? _nextCalvingDate;

  @override
  void initState() {
    super.initState();
    _calculateNextCalvingDate(); // Call the method to calculate days pregnant
    _calculateDaysPregnant(); // Call the method when the widget is initialized
  }
  Future<void> _calculateNextCalvingDate() async {
    try {
      // Initialize _nextCalvingDate to null
      _nextCalvingDate = null;

      // Retrieve the inseminations subcollection
      final QuerySnapshot inseminationsSnapshot = await FirebaseFirestore.instance
          .collection('Dairy_Cows')
          .doc(widget.cowData['id'])
          .collection('inseminations')
          .orderBy('date', descending: true) // Order by date in descending order to get the latest insemination
          .limit(1) // Limit to retrieve only the latest insemination
          .get();

      // Check if there's any insemination record
      if (inseminationsSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot latestInsemination = inseminationsSnapshot.docs.first;

        // Get the last insemination date
        final Timestamp inseminationDate = latestInsemination['date'];

        // Calculate the next calving date (adding the gestation period to the insemination date)
        final int gestationPeriodDays = 280; // Assuming a gestation period of 280 days
        final DateTime lastInseminationDate = inseminationDate.toDate();
        final DateTime nextCalvingDate = lastInseminationDate.add(Duration(days: gestationPeriodDays));

        // Calculate the number of days remaining before the next delivery
        final DateTime currentDate = DateTime.now();
        final Duration remainingDaysDuration = nextCalvingDate.difference(currentDate);
        final int remainingDays = remainingDaysDuration.inDays;

        // Update the state with the next calving date and remaining days
        setState(() {
          _nextCalvingDate = nextCalvingDate;
          _remainingDaysBeforeDelivery = remainingDays;
        });
      }
    } catch (error) {
      print("Error calculating next calving date: $error");
    }
  }


  Future<void> _calculateDaysPregnant() async {
    try {
      // Retrieve the inseminations subcollection
      final QuerySnapshot inseminationsSnapshot = await FirebaseFirestore.instance
          .collection('Dairy_Cows')
          .doc(widget.cowData['id'])
          .collection('inseminations')
          .orderBy('date', descending: true) // Order by date in descending order to get the latest insemination
          .limit(1) // Limit to retrieve only the latest insemination
          .get();

      // Check if there's any insemination record
      if (inseminationsSnapshot.docs.isNotEmpty) {
        final DocumentSnapshot latestInsemination = inseminationsSnapshot.docs.first;

        // Get the last insemination date
        final Timestamp inseminationDate = latestInsemination['date'];

        // Calculate the difference between the insemination date and the current date
        final DateTime currentDate = DateTime.now();
        final DateTime lastInseminationDate = inseminationDate.toDate();
        final Duration difference = currentDate.difference(lastInseminationDate);

        // Update the state with the number of days pregnant
        setState(() {
          _daysPregnant = difference.inDays;
        });
      }
    } catch (error) {
      print("Error calculating days pregnant: $error");
    }
  }



  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cow Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete,
              color: Colors.red,
              ),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Cow'),
                    content: const Text('Are you sure you want to delete this cow?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:BorderRadius.circular(12)
                            ),
                            child: const Text('Cancel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            )
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Delete record from Firestore
                          FirebaseFirestore.instance
                              .collection('Dairy_Cows')
                              .doc(widget.cowData['id'])
                              .delete();
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:BorderRadius.circular(12)
                            ),
                            child: const Text('Ok',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.cowData['cowImage'] ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            _buildDetailCard(
              title: 'Cow Details',
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildDetailRow('Name:', widget.cowData['name'] ?? ''),
                    const SizedBox(height:5),
                    _buildDetailRow('ID/TAG No:', widget.cowData['tagNumber'] ?? ''),
                    const SizedBox(height:5),
                    _buildDetailRow('Gender:', widget.cowData['gender'] ?? ''),
                    const SizedBox(height:5),
                    _buildDetailRow('Breed:', widget.cowData['breed'] ?? ''),
                    const SizedBox(height:5),
                    _buildDetailRow('Color/Markings:', widget.cowData['color'] ?? ''),
                    const SizedBox(height:5),
                    _buildDetailRow('DOB:', widget.cowData['DOB']?.toDate().toString() ?? ''),
                    const SizedBox(height:5),
                    Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Set Current Breeding Status'),
                                    content: SizedBox(
                                      width: 300, // Adjust the width as needed
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BreedingStatusDropdown(
                                              onStatusChanged: (selectedStatus) {
                                                // Update Firestore with the selected status
                                                if (selectedStatus != null) {
                                                  FirebaseFirestore.instance
                                                      .collection('Dairy_Cows')
                                                      .doc(widget.cowData['id'])
                                                      .update({'breeding_status': selectedStatus});
                                                }
                                              },
                                            ), // Use BreedingStatusDropdown as a form field
                                            SizedBox(height: 20), // Add some space between dropdown and buttons
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Validate the form
                                                    if (_formKey.currentState!.validate()) {
                                                      Navigator.of(context).pop(); // Close dialog
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: const Text(
                                                      'Set',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text('Breeding Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),

                              ),
                            ),
                            //second button first row

                            //third button first row

                          ],
                        ),
                        //Second row add another row

                      ],
                    )


                  ],
                ),
              ), onPressed: (){},
            ),
            //container showing the cow breeding details as well as te
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Card(
                child:Row(
                  children: [
                    //breeding Status
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      )
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                    children: [

                      if(widget.cowData['gender'].toLowerCase() == 'female')
                        Column(
                          children: [
                            const Text('Current Breeding Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                            ),
                            const SizedBox(height:5),
                            Text(widget.cowData['breeding_status'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            )
                          ],
                        ),
                      const SizedBox(height:5),
                     if(widget.cowData['breeding_status'] == 'Confirmed Pregnant')
                     Text('Days pregnant: $_daysPregnant',
                     style: const TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                       color: Colors.black54,
                     ),
                     ),



                    ],
                                 ),
                  ),
                        ),
                ),
                    //Next Calving date
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [

                              if(widget.cowData['gender'].toLowerCase() == 'female')
                                Column(
                                  children: [
                                    const Text('Next Calving Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height:5),
                                    Text(
                                       _nextCalvingDate != null ? DateFormat('dd MMMM yyyy').format(_nextCalvingDate!) : 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height:5),
                              Text('In Less than: $_remainingDaysBeforeDelivery days',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                    //Last Breeding date
                  ],
                ),
                           ),
             ),

            const SizedBox(height: 10),
            _buildDetailCard(
              title: 'Vaccination History',
              onPressed: () {
                // Handle add vaccination button press
                _showVaccinationDialog(context, widget.cowData);

              }, content: Container(),
            ),
            const SizedBox(height: 10),
            if (widget.cowData['gender'].toLowerCase() == 'female')

              _buildDetailCard(
              title: 'Insemination History',
              onPressed: () {
                // Handle add insemination button press
                _showInseminationDialog(context,widget.cowData);
              }, content: Container(),
            ),

            const SizedBox(height: 10),
            if (widget.cowData['gender'].toLowerCase() == 'female')

              _buildDetailCard(
              title: 'Pregnancy Status',
              onPressed: () {

              }, content: Container(),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required VoidCallback onPressed,
    required Widget content,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          content, // Display content passed to the content parameter
          // Display vaccination history if the title is 'Vaccination History'
          if (title == 'Vaccination History')
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dairy_Cows')
                  .doc(widget.cowData['id'])
                  .collection('vaccinations')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                // Display vaccination history
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child:Container(
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.lightBlueAccent,
                          border: Border.all(
                            color: Colors.grey,
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Date:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      ),
                                      Text(
                                        ' ${data['date'] != null ?
                                        DateFormat('d MMMM y').format(data['date'].toDate()) :
                                        'No date available'}',
                                        style: const TextStyle(
                                          fontSize: 16,

                                        ),
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Show confirmation dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete Vaccination Record'),
                                          content: Text('Are you sure you want to delete this vaccination record?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Delete record from Firestore
                                                FirebaseFirestore.instance
                                                    .collection('Dairy_Cows')
                                                    .doc(widget.cowData['id'])
                                                    .collection('vaccinations')
                                                    .doc(document.id)
                                                    .delete();
                                                Navigator.of(context).pop(); // Close dialog
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                ],
                              ),

                                Row(
                                children: [
                                  const Text('Vaccine Name:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['vaccineName'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Reason:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['reason'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Batch No:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['manufacturer'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Dose:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['dosage'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Route:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['route'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Vaccinated By:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['vaccinatorName'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Text('Comments:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['comments'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  }).toList(),
                );
              },
            ),

          // Display insemination history if the title is 'Insemination History'
          if (title == 'Insemination History')
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dairy_Cows')
                  .doc(widget.cowData['id'])
                  .collection('inseminations')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                // Display vaccination history
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child:Container(
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.orangeAccent,
                            border: Border.all(
                              color: Colors.grey,
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Row(
                                     children: [
                                       const Text('Date:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                       ),
                                       Text(
                                         ' ${data['date'] != null ?
                                         DateFormat('d MMMM y').format(data['date'].toDate()) :
                                         'No date available'}',
                                         style: const TextStyle(
                                           fontSize: 16,

                                         ),
                                       ),
                                     ],
                                   ),

                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Show confirmation dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Insemination Record'),
                                          content: const Text('Are you sure you want to delete this insemination record?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Delete record from Firestore
                                                FirebaseFirestore.instance
                                                    .collection('Dairy_Cows')
                                                    .doc(widget.cowData['id'])
                                                    .collection('inseminations')
                                                    .doc(document.id)
                                                    .delete();
                                                Navigator.of(context).pop(); // Close dialog
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                ],
                              ),

                              Row(
                                children: [
                                  const Text('Technician:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['technicianName'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Equipment Type:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['equipmentType'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Source:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['semenSource'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text('Quantity:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['quantity'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height:5),
                              Column(
                                children: [
                                  const Text('Comments:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(data['summary'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    );
                  }).toList(),
                );
              },
            ),
          if (title == 'Pregnancy Status')
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dairy_Cows')
                  .doc(widget.cowData['id'])
                  .collection('inseminations')
                  .orderBy('date', descending: true) // Order documents by date in descending order to get the latest record first
                  .limit(1) // Limit the result to only one document, i.e., the latest record
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                // Check if there's no document
                if (snapshot.data!.docs.isEmpty) {
                  return  Container();
                }

                // Get the latest insemination record
                Map<String, dynamic> data = snapshot.data!.docs.first.data() as Map<String, dynamic>;

                // Calculate days remaining until delivery
                DateTime inseminationDate = data['date'].toDate();
                DateTime today = DateTime.now();
                DateTime deliveryDate = inseminationDate.add(Duration(days: gestationPeriod));

                int daysRemaining = deliveryDate.difference(today).inDays;

                // Calculate pregnancy progress
                int totalPregnancyDays = deliveryDate.difference(inseminationDate).inDays;
                int daysElapsed = today.difference(inseminationDate).inDays;
                double progress = daysElapsed / totalPregnancyDays;

                // Determine color for the rectangular progress bar based on pregnancy progress
                Color tunnelColor = Colors.green; // Set color to green

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.greenAccent,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date Inseminated: ${data['date'] != null ? DateFormat('d MMMM y').format(data['date'].toDate()) : 'No date available'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                          // Other details...
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text('Days Remaining: $daysRemaining', style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Custom rectangular progress bar
                          Container(
                            width: MediaQuery.of(context).size.width, // Set the width of the progress bar
                            height: 24, // Set the height of the progress bar
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Add border radius to make it look rounded
                              border: Border.all(color: Colors.grey[300]!), // Add a border
                            ),
                            child: Stack(
                              children: [
                                // Background bar to show progress
                                Container(
                                  width: MediaQuery.of(context).size.width, // Set the width of the background bar
                                  height: 28, // Set the height of the background bar
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300], // Set background color
                                    borderRadius: BorderRadius.circular(12), // Add border radius to make it look rounded
                                  ),
                                ),
                                // Progress bar to indicate the progress
                                FractionallySizedBox(
                                  widthFactor: progress, // Set the width factor based on the progress
                                  child: Container(
                                    height: 28, // Set the height of the progress bar
                                    decoration: BoxDecoration(
                                      color: tunnelColor, // Set color based on pregnancy progress
                                      borderRadius: BorderRadius.circular(12), // Add border radius to make it look rounded
                                    ),
                                  ),
                                ),
                                // Percentage text at the bottom center
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      '${(progress * 100).toInt()}%', // Display progress percentage
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),




        ],
      ),
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _showVaccinationDialog(BuildContext context, Map<String, dynamic> cowData) {


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(
            child: Row(
              children: [
                const Text('Vaccinate:'),
               const SizedBox(width: 10),
               Text(cowData['name'] ?? '',
               style: const TextStyle(
                 fontSize: 24,
                 color: Colors.green,
                 fontWeight: FontWeight.bold,
                 fontFamily: "Georgia",
               ),
               ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child:Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RegisterForm(
                    controller: vaccineNameController,
                    hintsText: "Vaccine Name",
                    requiredMessage: "Vaccine Name Required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: vaccinatorNameController,
                    hintsText: "Veterinary's Name",
                    requiredMessage: "Vet's name required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: reasonController,
                    hintsText: "Reason For Vaccination",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: dosageController,
                    hintsText: "Dosage",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: routeController,
                    hintsText: "Administration method e.g Injection",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: manufacturerNameController,
                    hintsText: "Manufacturer/Batch No",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: commentController,
                    hintsText: "General Comments",
                    requiredMessage: "Please Give general comments",
                  ),
                  TextFormField(
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('y MMMM d').format(_selectedDate!)
                          : '',
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      hintText: 'Date Vaccinated',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter vaccination Date.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                  child: const Text('Cancel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),

                  )
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String cowId = cowData['id'];
                  DocumentReference cowRef = FirebaseFirestore.instance
                      .collection('Dairy_Cows').doc(cowId);
                  cowRef.collection('vaccinations').add({
                    'vaccineName': vaccineNameController.text,
                    'vaccinatorName': vaccinatorNameController.text,
                    'reason': reasonController.text,
                    'dosage': dosageController.text,
                    'route': routeController.text,
                    'manufacturer': manufacturerNameController.text,
                    'comments': commentController.text,
                    'date': _selectedDate
                  });

                  // Clear text fields upon successful registration
                  vaccineNameController.clear();
                  vaccinatorNameController.clear();
                  reasonController.clear();
                  dosageController.clear();
                  routeController.clear();
                  manufacturerNameController.clear();
                  commentController.clear();
                  Navigator.pop(context);//Close dialog form
                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Icon(Icons.check_circle, color: Colors.green, size: 50),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Success!', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Vaccination registered successfully'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                  // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        );
      },
    );
  }

  final int gestationPeriod = 280; // Assuming a standard gestation period of 280 days for cows


  void _showInseminationDialog(BuildContext context, Map<String, dynamic> cowData)  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(
            child: Row(
              children: [
                const Text('Inseminate:'),
                const SizedBox(width: 10),
                Text(cowData['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Georgia",
                  ),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child:Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: technicianController,
                    hintsText: "Technician Name",
                    requiredMessage: "Technician name required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: sourceController,
                    hintsText: "Semen Source e.g Bank",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: quantityController,
                    hintsText: "Quantity",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: equipmentController,
                    hintsText: "Equipment Type",
                    requiredMessage: "Field required",
                  ),
                  const SizedBox(height: 8.0),
                  RegisterForm(
                    controller: summaryController,
                    hintsText: "General Comments",
                    requiredMessage: "Please give general Comments",
                  ),
                  const SizedBox(height: 8.0),

                  TextFormField(
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('y MMMM d').format(_selectedDate!)
                          : '',
                    ),
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      hintText: 'Date Inseminated',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Insemination Date.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),

                  )
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String cowId = cowData['id'];
                  DocumentReference cowRef = FirebaseFirestore.instance
                      .collection('Dairy_Cows').doc(cowId);
                  cowRef.collection('inseminations').add({
                    'technicianName': technicianController.text,
                    'semenSource': sourceController.text,
                    'quantity': quantityController.text,
                    'equipmentType': equipmentController.text,
                    'summary': summaryController.text,
                    'date': _selectedDate
                  });

                  // Clear text fields upon successful registration
                  technicianController.clear();
                  sourceController.clear();
                  quantityController.clear();
                  equipmentController.clear();
                  summaryController.clear();

                  Navigator.pop(context);//Close dialog form dialog
                  // Show success dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Icon(Icons.check_circle, color: Colors.green, size: 50),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Success!', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Insemination registered successfully'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),


          ],
        );
      },
    );
  }

}
