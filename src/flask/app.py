from flask import Flask, redirect, url_for, request
import datetime
import json

from ..lotto.lib import roll

app = Flask(__name__)

class Lottery:
    def __init__(self, numbers, date = datetime.datetime.now()):
        self.numbers = numbers
        self.date = date.strftime("%B %d, %Y")

@app.route('/lotto', methods = ['POST', 'GET'])
def lotto():
    lotto = Lottery(roll())

    response = json.dumps(lotto.__dict__)
    return response

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=80)