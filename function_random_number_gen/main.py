import functions_framework
import random
from flask import jsonify


@functions_framework.http
def randomgen(request):
    randomNum = random.randint(1, 100)
    output = {"random": randomNum}
    return jsonify(output)