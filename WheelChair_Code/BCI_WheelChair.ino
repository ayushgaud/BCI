String Direction = "";
String Speed = "";
int SpeedValue;
#define M1_SPEED 5
#define M2_SPEED 6
#define M1_DIR1 3
#define M1_DIR2 2
#define M2_DIR1 7
#define M2_DIR2 4
void setup()
{
  Serial.begin(115200);
  pinMode(M1_SPEED,OUTPUT);
  pinMode(M2_SPEED,OUTPUT);
  pinMode(M1_DIR1,OUTPUT);
  pinMode(M1_DIR2,OUTPUT);
  pinMode(M1_DIR1,OUTPUT);
  pinMode(M1_DIR2,OUTPUT);

}
void loop()
{
  while (Serial.available() > 0) 
  {
    int inChar = Serial.read();

    if (isAlpha(inChar))
    {
      Direction += (char)inChar; 
    }
    else if(isDigit(inChar))
    {
      Speed += (char)inChar;
    }


  }
  if(Direction.length()>0 &&  Speed.length()>0)
  {
    
    
  SpeedValue=Speed.toInt();
  SpeedValue=constrain(SpeedValue,0,255);
  if (Direction.equalsIgnoreCase("F"))
  {
    analogWrite(M1_SPEED,SpeedValue);
    analogWrite(M2_SPEED,SpeedValue);
    digitalWrite(M1_DIR1,HIGH); 
    digitalWrite(M1_DIR2,LOW);
    digitalWrite(M2_DIR1,HIGH);
    digitalWrite(M2_DIR2,LOW);
    Serial.print(SpeedValue);
    Serial.println(" " + Direction);
  }
  if (Direction.equalsIgnoreCase("B"))
  {
    analogWrite(M1_SPEED,SpeedValue);
    analogWrite(M2_SPEED,SpeedValue);
    digitalWrite(M1_DIR1,LOW); 
    digitalWrite(M1_DIR2,HIGH);
    digitalWrite(M2_DIR1,LOW);
    digitalWrite(M2_DIR2,HIGH);
    Serial.print(SpeedValue);
    Serial.println(" " + Direction);
  }
  if (Direction.equalsIgnoreCase("R"))
  {
    analogWrite(M1_SPEED,SpeedValue);
    analogWrite(M2_SPEED,SpeedValue);
    digitalWrite(M1_DIR1,HIGH); 
    digitalWrite(M1_DIR2,LOW);
    digitalWrite(M2_DIR1,LOW);
    digitalWrite(M2_DIR2,HIGH);
    Serial.print(SpeedValue);
    Serial.println(" " + Direction);
  }
  if (Direction.equalsIgnoreCase("L"))
  {
    analogWrite(M1_SPEED,SpeedValue);
    analogWrite(M2_SPEED,SpeedValue);
    digitalWrite(M1_DIR1,LOW); 
    digitalWrite(M1_DIR2,HIGH);
    digitalWrite(M2_DIR1,HIGH);
    digitalWrite(M2_DIR2,LOW);
    Serial.print(SpeedValue);
    Serial.println(" " + Direction);
  }
  if (Direction.equalsIgnoreCase("S"))
  {
    analogWrite(M1_SPEED,SpeedValue);
    analogWrite(M2_SPEED,SpeedValue);
    digitalWrite(M1_DIR1,HIGH); 
    digitalWrite(M1_DIR2,HIGH);
    digitalWrite(M2_DIR1,HIGH);
    digitalWrite(M2_DIR2,HIGH);
    Serial.print(SpeedValue);
    Serial.println(" " + Direction);
  }
  Direction="";
      Speed ="";
  }
}







