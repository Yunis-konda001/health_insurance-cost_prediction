from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import numpy as np
import pandas as pd

# Load trained components from Part 1
model = joblib.load('best_model.pkl')          # Random Forest model
encoders = joblib.load('encoders.pkl')        # Label encoders for sex, smoker, region
scaler = joblib.load('scaler.pkl')            # Standard scaler for features
feature_columns = joblib.load('feature_columns.pkl')  # Feature order: [age, sex, bmi, children, smoker, region]

app = FastAPI(title="Insurance Cost Prediction API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Input data structure with range constraints
class InsuranceData(BaseModel):
    age: int = Field(..., ge=18, le=100, description="Age between 18 and 100")
    sex: str = Field(..., pattern="^(male|female)$", description="Either 'male' or 'female'")
    bmi: float = Field(..., ge=15.0, le=50.0, description="BMI between 15.0 and 50.0")
    children: int = Field(..., ge=0, le=10, description="Number of children between 0 and 10")
    smoker: str = Field(..., pattern="^(yes|no)$", description="Either 'yes' or 'no'")
    region: str = Field(..., pattern="^(northeast|northwest|southeast|southwest)$", description="Valid region")

# Output structure
class PredictionResponse(BaseModel):
    predicted_cost: float = Field(..., description="Predicted insurance cost in USD")
    model_used: str = Field(..., description="Name of the ML model used")
    input_data: dict = Field(..., description="Input data used for prediction")

@app.get("/")
def health_check():
    """API health check"""
    return {"status": "API is running", "model": "Random Forest"}

@app.post("/predict", response_model=PredictionResponse)
def predict_cost(data: InsuranceData):
    """Predict insurance cost using trained model"""
    try:
        # Convert input to array matching training format
        input_data = [data.age, data.sex, data.bmi, data.children, data.smoker, data.region]
        
        # Encode categorical variables using same encoders from training
        input_data[1] = encoders['sex'].transform([data.sex])[0]      # sex: female=0, male=1
        input_data[4] = encoders['smoker'].transform([data.smoker])[0]  # smoker: no=0, yes=1
        input_data[5] = encoders['region'].transform([data.region])[0]  # region: encoded 0-3
        
        # Create DataFrame with correct feature order
        input_df = pd.DataFrame([input_data], columns=feature_columns)
        
        # Make prediction (Random Forest doesn't need scaling, but we have scaler for consistency)
        prediction = model.predict(input_df)[0]
        
        return PredictionResponse(
            predicted_cost=round(prediction, 2),
            model_used="Random Forest",
            input_data={
                "age": data.age,
                "sex": data.sex,
                "bmi": data.bmi,
                "children": data.children,
                "smoker": data.smoker,
                "region": data.region
            }
        )
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction error: {str(e)}")

@app.get("/model-info")
def model_info():
    """Get model information"""
    return {
        "model_type": "Random Forest",
        "features": feature_columns,
        "categorical_encodings": {
            "sex": {str(k): int(v) for k, v in zip(encoders['sex'].classes_, encoders['sex'].transform(encoders['sex'].classes_))},
            "smoker": {str(k): int(v) for k, v in zip(encoders['smoker'].classes_, encoders['smoker'].transform(encoders['smoker'].classes_))},
            "region": {str(k): int(v) for k, v in zip(encoders['region'].classes_, encoders['region'].transform(encoders['region'].classes_))}
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)