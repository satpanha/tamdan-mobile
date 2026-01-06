import zlib
import urllib.request
import sys
import os

uml = r'''@startuml
' Domain models
class Athlete {
  - id: String
  - name: String
  - dateOfBirth: DateTime
  - gender: String
  - beltLevel: String
  - status: String
  + toString(): String
}

class User {
  - name: String
  - email: String
  - role: String
  - createdDate: DateTime
  + toString(): String
}

class CoachNotes {
  - id: String
  - trainingSessionId: String
  - type: String
  - message: String
  - createdAt: DateTime
}

class TrainingSessions {
  - id: String
  - dateTime: DateTime
  - athleteId: String
  - coachId: String
  - sessionType: String
  - trainingResultId: String?
}

class TrainingResults {
  - id: String
  - overallScore: double
  - controlScore: double
  - speedScore: double
  - strengthScore: int
}

class SkillRatings {
  - id: String
  - striking: int
  - endurance: int
  - defense: int
}

class StrengthSessions {
  - id: String
  - trainingSessionId: String
  - pushUps: int
  - sitUps: int
  - squats: int
  - kickPower: int
  - coreStrength: int
  - legStrength: int
  - coachNotes: String?
}

class TechnicalSessions {
  - id: String
  - trainingSessionId: String
  - speed: int
  - balance: int
  - control: int
  - roundhouseAccuracy: int
  - coachNotes: String?
}

class PhysicalConditioningSessions {
  - id: String
  - trainingSessionId: String
  - stamina: int
  - flexibility: int
  - reactionSpeed: int
  - coachNotes: String?
}

' Repositories / provider (behavioral)
class SessionRecord {
  - id: String
  - trainingSessionId: String
  - athleteId: String
  - sessionType: String
  - payload: Map<String,dynamic>
  - dateTime: DateTime
  + toDb(): Map
  + static fromDb(Map): SessionRecord
}

class SessionRepository {
  + instance: SessionRepository
  + save(SessionRecord): Future<void>
  + getByAthlete(String): Future<List<SessionRecord>>
  + deleteById(String): Future<int>
}

class DBProvider {
  + instance: DBProvider
  + insert(table, Map): Future<int>
  + query(table, where?, whereArgs?): Future<List<Map>>
  + delete(table, where?, whereArgs?): Future<int>
}

' Relationships / associations
Athlete "1" -- "0..*" TrainingSessions : has
TrainingSessions "0..1" -- "1" TrainingResults : aggregate
TrainingSessions "1" -- "0..*" CoachNotes : may_have
TrainingSessions "1" -- "0..1" StrengthSessions
TrainingSessions "1" -- "0..1" TechnicalSessions
TrainingSessions "1" -- "0..1" PhysicalConditioningSessions
SessionRepository ..> SessionRecord
SessionRepository ..> DBProvider
DBProvider ..> "sessions table"

@enduml
'''

# PlantUML encoding (deflate + custom base64)

def _encode6bit(b):
    if b < 10:
        return chr(48 + b)
    b -= 10
    if b < 26:
        return chr(65 + b)
    b -= 26
    if b < 26:
        return chr(97 + b)
    b -= 26
    if b == 0:
        return '-'
    if b == 1:
        return '_'
    return '?'


def _encode64(data: bytes) -> str:
    res = []
    i = 0
    while i < len(data):
        b1 = data[i]
        b2 = data[i+1] if i+1 < len(data) else 0
        b3 = data[i+2] if i+2 < len(data) else 0
        c1 = (b1 >> 2) & 0x3F
        c2 = ((b1 & 0x3) << 4) | ((b2 >> 4) & 0xF)
        c3 = ((b2 & 0xF) << 2) | ((b3 >> 6) & 0x3)
        c4 = b3 & 0x3F
        res.append(_encode6bit(c1))
        res.append(_encode6bit(c2))
        res.append(_encode6bit(c3))
        res.append(_encode6bit(c4))
        i += 3
    return ''.join(res)


def encode_plantuml(s: str) -> str:
    compressed = zlib.compress(s.encode('utf-8'))
    # strip zlib header and checksum
    compressed = compressed[2:-4]
    return _encode64(compressed)

if __name__ == '__main__':
    try:
        encoded = encode_plantuml(uml)
        url = 'https://www.plantuml.com/plantuml/png/' + encoded
        print('Fetching:', url)
        resp = urllib.request.urlopen(url)
        data = resp.read()
        out = os.path.join(os.path.dirname(__file__), '..', 'uml_diagram.png')
        out = os.path.abspath(out)
        with open(out, 'wb') as f:
            f.write(data)
        print('Saved PNG to', out)
    except Exception as e:
        print('Error:', e)
        sys.exit(1)
