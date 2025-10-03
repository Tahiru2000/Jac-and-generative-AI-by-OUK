from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

def run_jac(file_name, inputs):
    """Run Jac program with given inputs"""
    process = subprocess.Popen(
        ["jac", "run", file_name],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    out, err = process.communicate("\n".join(inputs))
    return out if out else err

@app.route("/")
def home():
    return render_template("index.html")

# ---------- Academic ----------
@app.route("/academic", methods=["GET", "POST"])
def academic():
    result = None
    if request.method == "POST":
        student_name = request.form["student_name"]
        num_courses = int(request.form["num_courses"])

        inputs = [student_name, str(num_courses)]
        for i in range(num_courses):
            score = request.form[f"score_{i}"]
            credit = request.form[f"credit_{i}"]
            inputs.append(score)
            inputs.append(credit)

        result = run_jac("academic.jac", inputs)

    return render_template("academic.html", result=result)

# ---------- Banking ----------
@app.route("/banking", methods=["GET", "POST"])
def banking():
    result = None
    if request.method == "POST":
        acc_type = request.form["account_type"]
        balance = request.form["balance"]
        inputs = [acc_type, balance]
        result = run_jac("banking.jac", inputs)
    return render_template("banking.html", result=result)

# ---------- Career ----------
@app.route("/career", methods=["GET", "POST"])
def career():
    result = None
    if request.method == "POST":
        field = request.form["field"]
        skills = request.form["skills"]
        inputs = [field, skills]
        result = run_jac("career.jac", inputs)
    return render_template("career.html", result=result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
