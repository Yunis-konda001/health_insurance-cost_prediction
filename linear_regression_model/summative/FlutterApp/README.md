# Insurance Cost Prediction Flutter App

A Flutter application that predicts healthcare insurance costs using a machine learning API.

## Features

- **6 Input Fields**: Age, Sex, BMI, Children, Smoker, Region
- **Input Validation**: Range constraints matching API requirements
- **API Integration**: Connects to deployed FastAPI backend
- **Error Handling**: Shows validation errors and API connection issues
- **Clean UI**: Material Design with proper organization

## Setup Instructions

1. **Install Flutter**: https://flutter.dev/docs/get-started/install

2. **Update API URL**: 
   - Open `lib/main.dart`
   - Replace `https://your-app-name.onrender.com/predict` with your actual API URL

3. **Run the app**:
   ```bash
   flutter pub get
   flutter run
   ```

## Input Validation

- **Age**: 18-100 years
- **BMI**: 15.0-50.0
- **Children**: 0-10
- **Sex**: Male/Female dropdown
- **Smoker**: Yes/No dropdown  
- **Region**: Northeast/Northwest/Southeast/Southwest dropdown

## API Integration

The app sends POST requests to `/predict` endpoint with JSON data:
```json
{
  "age": 25,
  "sex": "female", 
  "bmi": 25.0,
  "children": 0,
  "smoker": "yes",
  "region": "southwest"
}
```

## Task 3 Requirements ✅

- ✅ Single page application
- ✅ 6 text fields for all prediction variables
- ✅ "Predict" button
- ✅ Display area for results/errors
- ✅ Proper organization and layout
- ✅ Input validation and error handling