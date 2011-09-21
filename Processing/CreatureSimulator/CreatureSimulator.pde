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
import toxi.geom.Circle;


void setup()
{
  size(640, 480);

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
  fill(0, 20);
  rect(0, 0, width, height);

  // draw creatures

  for (Creature creature : creatures)
  {
    // rotate mouseX, mouseY into creature coords

    creature.update(millis());

    // test for broadcast...
    if (creature.mBroadcastingEmotion)
    {
      for (Creature c : creatures)
      {
        if (creature != c)
        {
          Vec2D[] intersections = creature.mBeamPoint.intersectsCircle(c.mBeamPoint);
          if (intersections != null && intersections.length > 0)
          {
            //Hit!
            fill(0, 255, 0, 80);
            for (Vec2D vis : intersections)
            {
              ellipse(vis.x, vis.y, 6, 6);
            }

            creature.setEmotion( updateExternalEmotionalState(creature.mEmotion, c.mEmotion) );
          }
        }
      }
    }

    if (creature == selectedCreature)
    {
      fill(255, 40);
      noStroke();
      pushMatrix();
      translate(creature.x, creature.y);
      rotate(creature.mRotation);
      ellipse(creature.width/2, creature.height/2, creature.width*2, creature.height*2);
      popMatrix();
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
    Creature creature = new Creature(mouseX, mouseY, 60.0f, 80.0f, 40.0f);
    creature.rotateSelf(random(0, TWO_PI));
    /*
    Creature creature = new Creature();
     creature.x = mouseX;
     creature.y = mouseY;
     creature.mRotation = random(0,TWO_PI);
     */
    creatures.add( creature );
  }
}


void mouseMoved()
{
}

void mouseReleased()
{
  selectedCreature = null;
}


void mouseDragged()
{
  if (selectedCreature != null)
  {
    if (keyPressed && key == CODED && keyCode == SHIFT)
    {
      selectedCreature.rotateSelf( (mouseY-pmouseY)*0.01f );
    }
    else
    {
      selectedCreature.move( (mouseX-pmouseX), (mouseY-pmouseY) );
    }
  }
}



class Creature extends toxi.geom.Rect
{
  Circle mBeamPoint;

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
    mBeamPoint = new Circle(30, 0, 10);
  }


  Creature(float _x, float _y, float _w, float _h, float _r)
  {
    super(_x, _y, _w, _h);
    mBeamPoint = new Circle(_w/2+_x, _y, _r);
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

  //
  // rotate a creature a certain number of radians
  //
  Creature rotateSelf(float amt)
  {  
    mRotation += amt;
    mBeamPoint.subSelf(this.x, this.y).rotate(amt).addSelf(this.x, this.y);

    println("BEAM:" + mBeamPoint);
    return this;
  }


  Creature move(float _x, float _y)
  {
    mBeamPoint.addSelf(_x, _y);
    this.x+=_x;
    this.y+=_y;

    return this;
  }


  Creature setEmotion(int emo)
  {
    if (emo < EMOTIONS_END && emo > 0)
      mEmotion = emo;
    else
      println("Bad emotion:" + emo);

    return this;
  }

  void render()
  {
    pushMatrix();

    // rotate
    translate(x, y);
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
    translate(this.width/2, 0);
    stroke(128);
    strokeWeight(1);
    //    ellipseMode(CENTER);
    //    ellipse(0, 0, this.width*0.1, this.height*0.1);

    // draw broadcat beam
    arc(0, 0, BeamRadius, BeamRadius, -PI/2-BeamAngle/2, -PI/2+BeamAngle/2);

    popMatrix();

    // done drawing creature
    popMatrix();

    if (mBroadcastingEmotion)
    {
      fill(255, 60);
      ellipseMode(CENTER);
      ellipse(mBeamPoint.x, mBeamPoint.y, mBeamPoint.getRadius()*2, mBeamPoint.getRadius()*2);
    }
  }

  // end Creature class
}


