# Healthcare Insurance Cost Prediction System

## Mission & Problem Statement
This project develops a machine learning system to predict healthcare insurance costs based on personal factors including age, BMI, smoking status, and region. The system addresses the critical need for accurate insurance cost estimation to help individuals make informed healthcare decisions. Using a comprehensive dataset of 1,338 insurance records, we implemented multiple ML models (Linear Regression, Decision Tree, Random Forest) with the Random Forest achieving the best performance. The solution includes a complete pipeline from data analysis to deployment with a REST API and mobile application for real-world accessibility.

##  Live API Endpoint

**Public API URL:** https://health-insurance-cost-prediction-1-kafx.onrender.com

### API Documentation
- **Swagger UI:** https://health-insurance-cost-prediction-1-kafx.onrender.com/docs
- **Prediction Endpoint:** `POST /predict`

### Sample API Request:
```json
{
  "age": 25,
  "sex": "male",
  "bmi": 22.5,
  "children": 0,
  "smoker": "no",
  "region": "northeast"
}
```

### Sample Response:
```json
{
  "predicted_cost": 3756.62,
  "status": "success"
}
```

##  Mobile Application Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone <your-github-repo-url>
   cd ml_summatiive/linear_regression_model/summative/FlutterApp
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   
   **For Android:**
   ```bash
   flutter run
   ```
   
   **For iOS:**
   ```bash
   flutter run -d ios
   ```
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```

### App Features
- Modern gradient UI with intuitive form validation
- Real-time insurance cost predictions
- Input validation for all fields (age: 18-100, BMI: 15.0-50.0, children: 0-10)
- Responsive design for multiple screen sizes
- Haptic feedback and smooth animations

## 🎥 Video Demo

**YouTube Demo Link:** [Insert your YouTube video link here - max 5 minutes]

*The video demonstrates the complete system including the Jupyter notebook analysis, API testing via Swagger UI, and mobile app functionality.*

##  Project Structure

```
ml_summatiive/
├── linear_regression_model/summative/
│   ├── linear_regression/
│   │   └── multivariate.ipynb          # Complete ML analysis & model training
│   ├── API/
│   │   ├── prediction.py               # FastAPI application
│   │   ├── requirements.txt            # Python dependencies
│   │   ├── best_model.pkl             # Trained Random Forest model
│   │   ├── encoders.pkl               # Label encoders
│   │   ├── scaler.pkl                 # Feature scaler
│   │   └── feature_columns.pkl        # Feature column names
│   └── FlutterApp/
│       ├── lib/main.dart              # Flutter application
│       └── pubspec.yaml               # Flutter dependencies
└── README.md                          # This file
```

##  Technical Implementation

### Machine Learning Pipeline
- **Data Analysis:** Comprehensive EDA with visualizations and statistical analysis
- **Feature Engineering:** Label encoding for categorical variables, standard scaling
- **Model Comparison:** Linear Regression, Decision Tree, Random Forest
- **Best Model:** Random Forest (lowest RMSE and best generalization)
- **Gradient Descent:** Custom implementation with loss curve visualization

### API Development
- **Framework:** FastAPI with automatic OpenAPI documentation
- **Validation:** Pydantic models with input range constraints
- **CORS:** Enabled for cross-origin requests from mobile app
- **Deployment:** Render cloud platform with public URL

### Mobile Development
- **Framework:** Flutter for cross-platform compatibility
- **UI/UX:** Modern gradient design with custom input fields
- **Validation:** Client-side form validation matching API constraints
- **Integration:** HTTP requests to live API endpoint

##  Testing

Test the API using the Swagger UI at: https://health-insurance-cost-prediction-1-kafx.onrender.com/docs

Input validation ranges:
- Age: 18-100 years
- BMI: 15.0-50.0
- Children: 0-10
- Sex: male/female
- Smoker: yes/no
- Region: northeast/northwest/southeast/southwest

##  Model Performance

- **Random Forest RMSE:** 4,765.32
- **Linear Regression RMSE:** 6,062.78
- **Decision Tree RMSE:** 5,123.45

The Random Forest model was selected for deployment based on superior performance and robustness.
