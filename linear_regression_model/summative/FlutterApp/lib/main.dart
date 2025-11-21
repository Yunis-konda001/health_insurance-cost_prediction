import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const InsurancePredictionApp());
}

class InsurancePredictionApp extends StatelessWidget {
  const InsurancePredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insurance Cost Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      home: const PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _bmiController = TextEditingController();
  final _childrenController = TextEditingController();
  
  String _selectedSex = 'male';
  String _selectedSmoker = 'no';
  String _selectedRegion = 'northeast';
  
  String _result = '';
  bool _isLoading = false;

  final String apiUrl = 'https://health-insurance-cost-prediction-1-kafx.onrender.com/predict';

  Future<void> _predictCost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'age': int.parse(_ageController.text),
          'sex': _selectedSex,
          'bmi': double.parse(_bmiController.text),
          'children': int.parse(_childrenController.text),
          'smoker': _selectedSmoker,
          'region': _selectedRegion,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = 'Predicted Cost: \$${data['predicted_cost']}\nModel: ${data['model_used']}';
        });
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          _result = 'Error: ${error['detail']}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error: Unable to connect to API\nPlease check your internet connection';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6366F1),
                      const Color(0xFF8B5CF6),
                      const Color(0xFFEC4899),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.health_and_safety,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Insurance Cost\nPredictor',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get instant healthcare cost predictions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Input Fields Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 24),
              
                              // Age Field
                              _buildInputField(
                                controller: _ageController,
                                label: 'Age',
                                hint: 'Enter your age (18-100)',
                                icon: Icons.cake,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter age';
                                  final age = int.tryParse(value);
                                  if (age == null || age < 18 || age > 100) {
                                    return 'Age must be between 18 and 100';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Sex Dropdown
                              _buildDropdownField(
                                label: 'Gender',
                                value: _selectedSex,
                                icon: Icons.person,
                                items: const [
                                  DropdownMenuItem(value: 'male', child: Text('Male')),
                                  DropdownMenuItem(value: 'female', child: Text('Female')),
                                ],
                                onChanged: (value) => setState(() => _selectedSex = value!),
                              ),
                              const SizedBox(height: 20),

                              // BMI Field
                              _buildInputField(
                                controller: _bmiController,
                                label: 'BMI (Body Mass Index)',
                                hint: 'Enter your BMI (15.0-50.0)',
                                icon: Icons.monitor_weight,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter BMI';
                                  final bmi = double.tryParse(value);
                                  if (bmi == null || bmi < 15.0 || bmi > 50.0) {
                                    return 'BMI must be between 15.0 and 50.0';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Children Field
                              _buildInputField(
                                controller: _childrenController,
                                label: 'Number of Children',
                                hint: 'Enter number of children (0-10)',
                                icon: Icons.child_care,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Please enter number of children';
                                  final children = int.tryParse(value);
                                  if (children == null || children < 0 || children > 10) {
                                    return 'Children must be between 0 and 10';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Smoker Dropdown
                              _buildDropdownField(
                                label: 'Smoking Status',
                                value: _selectedSmoker,
                                icon: Icons.smoking_rooms,
                                items: const [
                                  DropdownMenuItem(value: 'yes', child: Text('Yes, I smoke')),
                                  DropdownMenuItem(value: 'no', child: Text('No, I don\'t smoke')),
                                ],
                                onChanged: (value) => setState(() => _selectedSmoker = value!),
                              ),
                              const SizedBox(height: 20),

                              // Region Dropdown
                              _buildDropdownField(
                                label: 'Region',
                                value: _selectedRegion,
                                icon: Icons.location_on,
                                items: const [
                                  DropdownMenuItem(value: 'northeast', child: Text('Northeast')),
                                  DropdownMenuItem(value: 'northwest', child: Text('Northwest')),
                                  DropdownMenuItem(value: 'southeast', child: Text('Southeast')),
                                  DropdownMenuItem(value: 'southwest', child: Text('Southwest')),
                                ],
                                onChanged: (value) => setState(() => _selectedRegion = value!),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Predict Button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            HapticFeedback.lightImpact();
                            _predictCost();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Predict Insurance Cost',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Result Display
                      if (_result.isNotEmpty)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: _result.startsWith('Error')
                                ? LinearGradient(
                                    colors: [Colors.red.shade50, Colors.red.shade100],
                                  )
                                : LinearGradient(
                                    colors: [Colors.green.shade50, Colors.green.shade100],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _result.startsWith('Error')
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                _result.startsWith('Error')
                                    ? Icons.error_outline
                                    : Icons.check_circle_outline,
                                size: 48,
                                color: _result.startsWith('Error')
                                    ? Colors.red.shade600
                                    : Colors.green.shade600,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _result.startsWith('Error') ? 'Prediction Failed' : 'Prediction Result',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _result.startsWith('Error')
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _result,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _result.startsWith('Error')
                                      ? Colors.red.shade600
                                      : Colors.green.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    _childrenController.dispose();
    super.dispose();
  }
}