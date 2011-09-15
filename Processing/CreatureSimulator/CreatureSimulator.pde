/**
 * Creatures simulator
 *
 * by Evan Raskob
 *
 */

ArrayList<Creature> creatures = new ArrayList<Creature>();

Creature selectedCreature;

import toxi.geom.Vec2D;
import toxi.geom.Rect;


void setup()
{
  size(640,480);
  
  selectedCreature = null;
  
  println(maxStates+"");

  setupStates();

  println("= {");
  for (int i=HAPPY; i < EMOTIONS_END; i++)
    for (int j=HAPPY; j < EMOTIONS_END; j++)
      for (int k=HAPPY; k < EMOTIONS_END; k++)
      {
        int index = EmotionStateTo3DIndex(i, j, k);
        //print("("+index+")");

        ExternalStateMap[index] = ExternalStateMap3D[i][j][k];
        //        print(ExternalStateMap3D[index]+"");
        //        if (index < maxStates) print(",");
      }

  for (int i=0; i<maxStates; i++)
  {
    print(ExternalStateMap[i]+"");
    if (i < maxStates-1) print(",");
  }
  println("};");
}



void draw()
{
  background(0);

  // draw creatures

  for (Creature creature : creatures)
  {
    // rotate mouseX, mouseY into creature coords

    creature.update(millis());


    if (creature == selectedCreature)
    {
      fill(255, 40);
      noStroke();
      ellipse(mouseX, mouseY, creature.width*2, creature.height*2);
    }
    creature.render();
  }
}



void mousePressed()
{

  for (Creature creature : creatures)
  {
    // rotate mouseX, mouseY into creature coords

    Vec2D mRotated = new Vec2D(mouseX-creature.x, mouseY-creature.y);
    mRotated.rotate(-creature.mRotation).addSelf(creature.x, creature.y);

    print("rotation:" + creature.mRotation + "   ");
    print("mx,my:" + mouseX+","+mouseY);
    println("   Rmx,Rmy:" + mRotated.x+","+mRotated.y);

    if (creature.containsPoint( mRotated ))
    {
      selectedCreature = creature;
      println("HIT ONE!");
      break;
    }
  }

  if (selectedCreature == null)
  {
    println("New creature!");
    Creature creature = new Creature();
    creature.x = mouseX;
    creature.y = mouseY;
    creature.mRotation = random(0,TWO_PI);
    creatures.add( creature );
  }
}


void mouseMoved()
{
  if (selectedCreature != null)
  {
    selectedCreature.x = mouseX;
    selectedCreature.y = mouseY;
  }
}

void mouseReleased()
{
  selectedCreature = null;
}


void mouseDragged()
{
  if (selectedCreature != null)
  {
    selectedCreature.x += (mouseX-pmouseX);
    selectedCreature.y += (mouseY-pmouseY);
  }
}



class Creature extends toxi.geom.Rect
{
  float BeamAngle         = PI/4; // radians
  float BeamRadius        = 60.0f; // pixels
  int BeamFlashDuration   = 200;   // flash length in millis
  int BeamTransmitInterval= 2000;   // between external emotion transmissions, in millis

  int InternalChangeInterval= 2000;   // between external emotion transmissions, in millis

  int   mEmotion                = HAPPY;
  float mRotation               = 0.0f; //radians

  int mLastTransmitTime         = 0;  // in millis
  int mLastInternalTime         = 0;
  int mCurrentTime              = 0;  // in millis

  boolean mBroadcastingEmotion  = false;

  Creature()
  {
    super(0, 0, 60, 80);
  }     


  void update(int timeElapsed)
  {
    mCurrentTime = timeElapsed;
    
    //update internal state
    
     if (mCurrentTime-mLastInternalTime >= InternalChangeInterval)
    {
      // change
      mEmotion = updateInternalEmotionalState(mEmotion);
      mLastInternalTime = mCurrentTime;
    }
    
    //update external state
    if (mCurrentTime-mLastTransmitTime >= BeamTransmitInterval)
    {
      // broadcast
      mBroadcastingEmotion = true;
      mLastTransmitTime = mCurrentTime;
    }
    else
    {
      mBroadcastingEmotion = false;
    }
  }


  void render()
  {
    pushMatrix();
    
    // rotate
    translate(x,y);
    rotate(mRotation);
//    translate(-width/2,-height/2);

    // draw body
    fill( stateColors[mEmotion] );
    stroke(255);
    strokeWeight(2);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);

    // draw broadcast nub
    pushMatrix();
    translate(this.width/2,0);
    stroke(128);
    strokeWeight(1);
    ellipseMode(CENTER);
    ellipse(0, 0, this.width*0.1, this.height*0.1);

    // draw broadcat beam
    arc(0, 0, BeamRadius, BeamRadius, -PI/2-BeamAngle/2, -PI/2+BeamAngle/2);
    
    popMatrix();
    
    // done drawing creature
    popMatrix();
  }

  // end Creature class
}




