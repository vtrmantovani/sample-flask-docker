from flask import Blueprint, jsonify

common = Blueprint('common', __name__)


@common.route('/', methods=['GET'])
def index():
    return jsonify({"service": "API Sample Flask Docker",
                    "version": "1.0"})