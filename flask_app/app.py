from datetime import datetime
from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:jeeva@localhost/kavigai'
db = SQLAlchemy(app)

class Goals(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    begin_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    url = db.Column(db.String(255), nullable=True)
    status = db.Column(db.String(50), nullable=False, default='New')

@app.route('/api/goals', methods=['GET'])
def get_goals():
    goals = Goals.query.all()
    goals_list = []
    for goal in goals:
        goals_list.append({
            'id': goal.id,
            'name': goal.name,
            'description': goal.description,
            'begin_date': goal.begin_date.strftime('%Y-%m-%d'),
            'end_date': goal.end_date.strftime('%Y-%m-%d'),
            'url': goal.url,
            'status': goal.status
        })
    return jsonify({'goals': goals_list})

@app.route('/api/goals', methods=['POST'])
def create_goals():
    data = request.json

    name = data.get('name')
    description = data.get('description')
    begin_date_str = data.get('begin_date')
    end_date_str = data.get('end_date')
    url = data.get('url')
    status = data.get('status', 'New')

    if not name or not description or not begin_date_str or not end_date_str:
        return jsonify({'message': 'Name, description, begin_date, and end_date are required'}), 400

    try:
        begin_date = datetime.strptime(begin_date_str, '%Y-%m-%d').date()
        end_date = datetime.strptime(end_date_str, '%Y-%m-%d').date()
    except ValueError:
        return jsonify({'message': 'Invalid date format. Please use YYYY-MM-DD'}), 400

    goals = Goals(
        name=name,
        description=description,
        begin_date=begin_date,
        end_date=end_date,
        url=url,
        status=status
    )

    db.session.add(goals)
    db.session.commit()

    return jsonify({'message': 'Goal created successfully'}), 201

if __name__ == '__main__':
    app.run(debug=True)
