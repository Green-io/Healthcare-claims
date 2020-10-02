import numpy as np
from flask import Flask, request, render_template, jsonify
import pickle

app = Flask(__name__)
model_knn = pickle.load(open('model_knn.pkl', 'rb'))
scalar_minmax=pickle.load(open('scalar_minmax.pkl', 'rb'))


#['InscClaimAmtReimbursed','ChronicCond_Alzheimer', 'ChronicCond_Heartfailure',
#   'ChronicCond_KidneyDisease', 'ChronicCond_Cancer',\
#        'ChronicCond_ObstrPulmonary', 'ChronicCond_Depression',
#       'ChronicCond_Diabetes', 'ChronicCond_IschemicHeart',
#       'ChronicCond_Osteoporasis', 'ChronicCond_rheumatoidarthritis',
#       'ChronicCond_stroke', 'IPAnnualReimbursementAmt',
#       'OPAnnualReimbursementAmt','Age', 'Patient_IN','NumberOfDisease']
#[amt1, d1,d2,d3,d4,d5,d6,d7,d8,d9,d10, d11, amt2, amt3,age, patin, nod]

@app.route('/api',methods=['GET'])
def api():
    dic=request.args.to_dict()
    print(dic)
    int_features = [float(x) for x in dic.values()]

    final_features = [np.array(int_features)]
    final_features=scalar_minmax.transform(final_features)

    prediction = model_knn.predict(final_features)

    if prediction[0]==0:
        return jsonify(isFraud=False);
    else:
        return jsonify(isFraud=True);


if __name__ == "__main__":
    app.run(debug=True)