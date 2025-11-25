import 'package:flutter/material.dart';

class laundry_appScreen extends StatefulWidget {
  const laundry_appScreen({super.key});

  @override
  State<laundry_appScreen> createState() => _laundry_appScreenState();
}

class  _laundry_appScreenState extends State<laundry_appScreen> {
  TextEditingController clothesController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  String selectedTemperature = 'low';
  String cycleType = 'delicate';

  double laundryTime = 0.0;
  double loads=0.0;
  String message='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Laundry load planner', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child:
           
           Container(
            padding: EdgeInsets.all(16.0),
            margin:EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(255, 31, 103, 161) 
            ),
            width : 350,   
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Row(children:[
                  SizedBox(width: 100,child:Text('number of clothes:')),
                  SizedBox( 
                    width: 200 ,
                    child:TextField(
                      keyboardType: TextInputType.number,
                      controller: clothesController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'enter number of clothes',
                      ),
                    ) 
                  ),
                ]
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(width: 100,child:Text('Machine Capacity (5/10/15)(kg):')),
                  SizedBox( width: 200 ,
                  child:TextField(
                    keyboardType: TextInputType.number,
                    controller: capacityController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'enter machine capacity',
                    ),
                  )    
                ),
              ]
            ),
          
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 100,child:Text('temperature:')),
                DropdownButton<String>(
                  value: selectedTemperature,
                  items: <String>['low', 'medium', 'high'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedTemperature = newValue!;
                    setState(() {
                      
                    });
                  },
                ),
              ],
            ),

           

            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 100,child:Text('cycle type:')),
                DropdownButton<String>(
                  value: cycleType,
                  items: <String>[ 'delicate','normal', 'heavy'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    cycleType = newValue!;
                    setState(() {
                      
                    });
                  },
                ),
              ],
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                onPressed: () {
                  calculateLT(selectedTemperature, cycleType);

                },
                child: Text('calculate Laundry Time')
                ),

              ElevatedButton(
                onPressed: () {
                  clothesController.clear();
                  capacityController.clear();

                  laundryTime=0.0;
                  loads=0.0;
                  message='';
                  setState(() {});
                },
                child: Text('clear')
                )
              ],
            ),
            
            
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              margin:EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 241, 208, 219)),
                borderRadius: BorderRadius.circular(8.0),
                color: const Color.fromARGB(255, 109, 112, 114) 
            ),
            child: Column(
              children: [
              Text('Laundry Time: $laundryTime minutes',
              style: TextStyle(fontSize: 18),
            ), 
            Text('Number of loads: $loads',
              style: TextStyle(fontSize: 18),
            ),
            Text(message,style: TextStyle(fontSize: 18,color: Colors.red,)),
              ]

            ),
              
            ),

            
          ],
      ),
    ),
  
      ),
      
      
      )
  );
    
  }
  
  void calculateLT( String temp, String cycle) {

    // 1. initialize the basetime of a washing machine that is 30 minutes
    double baseTime = 30.0;
    double? clothes = double.tryParse(clothesController.text);
    double? capacity = double.tryParse(capacityController.text);

    // 2. validation part
    // if the the input from the user are missing or less than zero, it will show error message and stop calculation
    if (clothes == null || clothes <=0 || capacity == null || capacity <=0) {
      setState(() { 
        laundryTime=0.0;
        loads=0.0;
        message = 'invalid input';          
    });
      return;
    }

    
    // 3. the formula of how many loads for the laundry to complete
    loads = clothes / capacity;
    
    // 4. adjusting the basetime according to the cycle type and temparature
    // 'delicate' means a shorter base time of washing mashine and 'heavy' means a longer basetime for the washing machine
    // higher temparature adds more time to the basetime
    if (temp == 'medium'){
      baseTime +=5.0;
    }else if (temp == 'high'){
      baseTime +=10.0;  
    }

    if (cycle == 'delicate') {
      baseTime =25.0;
    }else if (cycle == 'heavy'){
      baseTime =40.0;
    }
      
    
      setState(() { 

        // 5. final calculation
        // basetime and loads will be multuply to get total laundry duration
        // laudry time will be round up to 2 decimal places because of time was in minutes
        loads=double.parse(loads.toStringAsFixed(2));
        laundryTime = double.parse((baseTime * loads).toStringAsFixed(2));
        message='';
    }); 
    }
}

    
 
