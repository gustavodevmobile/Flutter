import 'package:flutter/material.dart';
import 'package:estudamais/providers/global_providers.dart';
import 'package:provider/provider.dart';

class BoxAlternativesCorrects extends StatefulWidget {
  final String alternative;
  final String option;
  final String response;
 

  const BoxAlternativesCorrects(
    this.alternative,
    this.option,
    this.response,
    
    {
    super.key,
  });

  @override
  State<BoxAlternativesCorrects> createState() =>
      _BoxAlternativesCorrectsState();
}

class _BoxAlternativesCorrectsState extends State<BoxAlternativesCorrects> {
  

  bool answered = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Consumer<GlobalProviders>(
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: MediaQuery.of(context).size.width,
                  // height: 60,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 3),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                    color: widget.alternative == widget.response ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.black38,
                    ),
                  ),
                  child: InkWell(
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1, color: Colors.black26),
                            color: Colors.white),
                        child: Text(
                          widget.option,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      title: Text(
                        widget.alternative,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                   
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
